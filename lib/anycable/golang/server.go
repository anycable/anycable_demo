package main

import (
	"flag"
	"log"
    "time"
	"net/http"
    "encoding/json"

	"github.com/gorilla/websocket"
)

const (
    // Time allowed to write a message to the peer.
    writeWait = 10 * time.Second

    // Send pings to peer with this period. Must be less than pongWait.
    pingPeriod = 3 * time.Second

    // Maximum message size allowed from peer.
    maxMessageSize = 512
)

// Conn is an middleman between the websocket connection and the hub.
type Conn struct {
    // The websocket connection.
    ws *websocket.Conn

    // Connection identifiers as received from RPC server
    identifiers string

    // Connection subscriptions
    subscriptions map[string]bool

    // Buffered channel of outbound messages.
    send chan []byte
}

var rpchost = flag.String("rpc", "0.0.0.0:50051", "rpc service address")

var addr = flag.String("addr", "0.0.0.0:8080", "http service address")

var upgrader = websocket.Upgrader{
    CheckOrigin: func(r *http.Request) bool { return true },
    Subprotocols: []string{"actioncable-v1-json"},
    ReadBufferSize:  1024,
    WriteBufferSize: 1024,
}

// readPump pumps messages from the websocket connection to the hub.
func (c *Conn) readPump() {
    defer func() {
        log.Printf("Disconnect on read error")
        app.Disconnected(c)
        c.ws.Close()
    }()
    for {
        _, message, err := c.ws.ReadMessage()

        if err != nil {
            if websocket.IsUnexpectedCloseError(err, websocket.CloseGoingAway) {
                log.Printf("read error: %v", err)
            }
            break
        }

        msg := &Message{}

        if err := json.Unmarshal(message, &msg); err != nil {
            log.Printf("Unknown message: %s", message)
        }else{
            switch msg.Command {
                case "subscribe":
                    app.Subscribe(c, msg)
                case "unsubscribe":
                    app.Unsubscribe(c, msg)
                case "message":
                    app.Perform(c, msg)
                default:
                    log.Printf("Unknown command: %s", msg.Command)
            }            
        }
    }
}

// write writes a message with the given message type and payload.
func (c *Conn) write(mt int, payload []byte) error {
    c.ws.SetWriteDeadline(time.Now().Add(writeWait))
    return c.ws.WriteMessage(mt, payload)
}

func (c *Conn) writePump() {
    defer c.ws.Close()
    for {
        select {
            case message, ok := <-c.send:
                if !ok {
                    // The hub closed the channel.
                    c.write(websocket.CloseMessage, []byte{})
                    return
                }

                c.ws.SetWriteDeadline(time.Now().Add(writeWait))
                w, err := c.ws.NextWriter(websocket.TextMessage)
                if err != nil {
                    return
                }
                w.Write(message)

                if err := w.Close(); err != nil {
                    return
                }
        }
    }
}


// serveWs handles websocket requests from the peer.
func serveWs(w http.ResponseWriter, r *http.Request) {
    ws, err := upgrader.Upgrade(w, r, nil)
    if err != nil {
        log.Println(err)
        return
    }

    response := rpc.VerifyConnection(r)

    if response.Status != 1 {
        log.Println("Auth Failed")
        ws.Close()
        return
    }

    log.Printf("Connection identifiers: %s", response.Identifiers)

    conn := &Conn{send: make(chan []byte, 256), ws: ws, identifiers: response.Identifiers, subscriptions: make(map[string]bool)}
    app.Connected(conn, response.Transmissions)
    go conn.writePump()
    conn.readPump()
}

func main() {
	flag.Parse()
	log.SetFlags(0)
    go hub.run()

    app.Pinger = &Pinger{interval: pingPeriod, cmd: make(chan string)}

    rpc.Init(*rpchost)
    defer rpc.Close()

    app.Subscriber = &Subscriber{host: "redis://localhost:6379/5", channel: "anycable"}
    go app.Subscriber.run()

    log.Printf("Running websocket server on %s", *addr)
	http.HandleFunc("/cable", serveWs)
	log.Fatal(http.ListenAndServe(*addr, nil))
}
