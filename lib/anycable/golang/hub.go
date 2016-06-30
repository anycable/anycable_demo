package main

import (
  "log"
)

type SubscriptionInfo struct {
  conn *Conn
  stream string
}

type StreamMessage struct {
  stream string
  data []byte
}

type Hub struct {
  // Registered connections.
  connections map[*Conn]bool

  // Messages for all connections.
  broadcast chan []byte

  // Messages for specified stream.
  stream_broadcast chan *StreamMessage

  // Register requests from the connections.
  register chan *Conn

  // Unregister requests from connections.
  unregister chan *Conn

  // Subscribe requests to strreams.
  subscribe chan *SubscriptionInfo

  // Unsubscribe requests from streams.
  unsubscribe chan *Conn

  // Maps streams to connections
  streams map[string]map[*Conn]bool

  // Maps connections to streams
  connection_streams map[*Conn][]string
}

var hub = Hub{
  broadcast: make(chan []byte),
  stream_broadcast: make(chan *StreamMessage),
  register: make(chan *Conn),
  unregister: make(chan *Conn),
  subscribe: make(chan *SubscriptionInfo),
  unsubscribe: make(chan *Conn),
  connections: make(map[*Conn]bool),
  streams: make(map[string]map[*Conn]bool),
  connection_streams: make(map[*Conn][]string),
}

func (h *Hub) run() {
  for {
    select {
      case conn := <-h.register:
        log.Printf("Register connection %v", conn)
        h.connections[conn] = true

      case conn := <-h.unregister:
        log.Printf("Unregister connection %v", conn)  
        if _, ok := h.connections[conn]; ok {
          delete(h.connections, conn)
          close(conn.send)
        }

      case message := <-h.broadcast:
        log.Printf("Broadcast message %s", message)
        for conn := range h.connections {
          select {
            case conn.send <- message:
            default:
              close(conn.send)
              delete(hub.connections, conn)
          }
        }

      case stream_message := <- h.stream_broadcast:
        log.Printf("Broadcast to stream %s: %s", stream_message.stream, stream_message.data)

        if _, ok := h.streams[stream_message.stream]; !ok {
          log.Printf("No connections for stream %s", stream_message.stream)
          return
        }

        for conn := range h.streams[stream_message.stream] {
          select {
            case conn.send <- stream_message.data:
            default:
              close(conn.send)
              delete(hub.connections, conn)
          }
        }

      case subinfo := <- h.subscribe:
        log.Printf("Subscribe to stream %s for %s", subinfo.stream, subinfo.conn.identifiers)

        if _, ok := h.streams[subinfo.stream]; !ok {
          h.streams[subinfo.stream] = make(map[*Conn]bool)
        }
        
        h.streams[subinfo.stream][subinfo.conn] = true
        h.connection_streams[subinfo.conn] = append(
          h.connection_streams[subinfo.conn],
          subinfo.stream)

      case conn := <- h.unsubscribe:
        log.Printf("Unsubscribe from all streams %s", conn.identifiers)

        for _, stream := range h.connection_streams[conn] {
          delete(h.streams[stream], conn)
        }

        delete(h.connection_streams, conn)
    }
  }
}

func (h *Hub) Size() int {
  return len(h.connections)
}
