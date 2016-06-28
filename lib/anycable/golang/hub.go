package main

import (
    "log"
)

type SubscriptionInfo struct {
    conn *Conn
    channel string
}

type Hub struct {
    // Registered connections.
    connections map[*Conn]bool

    // Inbound messages from the connections.
    broadcast chan []byte

    // Register requests from the connections.
    register chan *Conn

    // Unregister requests from connections.
    unregister chan *Conn

    // Subscribe requests to strreams.
    subscribe chan *SubscriptionInfo

    // Unsubscribe requests from streams.
    unsubscribe chan *SubscriptionInfo

    // Maps streams to connections
    streams map[string][]*Conn

    // Maps connections to streams
    connection_streams map[*Conn][]string
}

var hub = Hub{
    broadcast:   make(chan []byte),
    register:    make(chan *Conn),
    unregister:  make(chan *Conn),
    subscribe: make(chan *SubscriptionInfo),
    unsubscribe: make(chan *SubscriptionInfo),
    connections: make(map[*Conn]bool),
    streams: make(map[string][]*Conn),
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
        }
    }
}
