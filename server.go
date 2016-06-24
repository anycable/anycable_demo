// Copyright 2015 The Gorilla WebSocket Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// +build ignore

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

    // Buffered channel of outbound messages.
    send chan []byte
}

// hub maintains the set of active connections and broadcasts messages to the
// connections.
type Hub struct {
    // Registered connections.
    connections map[*Conn]bool

    // Inbound messages from the connections.
    broadcast chan []byte

    // Register requests from the connections.
    register chan *Conn

    // Unregister requests from connections.
    unregister chan *Conn
}

var hub = Hub{
    broadcast:   make(chan []byte),
    register:    make(chan *Conn),
    unregister:  make(chan *Conn),
    connections: make(map[*Conn]bool),
}

func (h *Hub) run() {
    for {
        select {
        case conn := <-h.register:
            h.connections[conn] = true
        case conn := <-h.unregister:
            if _, ok := h.connections[conn]; ok {
                delete(h.connections, conn)
                close(conn.send)
            }
        case message := <-h.broadcast:
            for conn := range h.connections {
                select {
                case conn.send <- message:
                default:
                    close(conn.send)
                    delete(hub.connections, conn)
                }
            }
        }
    }
}

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
        hub.unregister <- c
        c.ws.Close()
    }()
    for {
        _, message, err := c.ws.ReadMessage()
        if err != nil {
            if websocket.IsUnexpectedCloseError(err, websocket.CloseGoingAway) {
                log.Printf("error: %v", err)
            }
            break
        }
        hub.broadcast <- message
    }
}

// write writes a message with the given message type and payload.
func (c *Conn) write(mt int, payload []byte) error {
    c.ws.SetWriteDeadline(time.Now().Add(writeWait))
    return c.ws.WriteMessage(mt, payload)
}

func (c *Conn) writePump() {
    ticker := time.NewTicker(pingPeriod)
    defer func() {
        ticker.Stop()
        c.ws.Close()
    }()
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
        case <-ticker.C:
            if err := c.write(websocket.TextMessage, cablePingMessage()); err != nil {
                return
            }
        }
    }
}

// Conn is an middleman between the websocket connection and the hub.
type PingMessage struct {
    // The websocket connection.
    Type string `json:"type"`
    // Buffered channel of outbound messages.
    Timestamp int64 `json:"message"`
}

func cablePingMessage() []byte {
    jsonStr, _ := json.Marshal(&PingMessage{Type: "ping", Timestamp: time.Now().Unix()})
    return jsonStr
}

// serveWs handles websocket requests from the peer.
func serveWs(w http.ResponseWriter, r *http.Request) {
    ws, err := upgrader.Upgrade(w, r, nil)
    if err != nil {
        log.Println(err)
        return
    }
    conn := &Conn{send: make(chan []byte, 256), ws: ws}
    hub.register <- conn
    go conn.writePump()
    conn.readPump()
}

func main() {
	flag.Parse()
	log.SetFlags(0)
    go hub.run()
    log.Printf("Running websocket server on %s", *addr)
	http.HandleFunc("/cable", serveWs)
	log.Fatal(http.ListenAndServe(*addr, nil))
}
