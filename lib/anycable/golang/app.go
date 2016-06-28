package main

import (
  "log"
  "encoding/json"
)

type App struct {
}

const (
  CONFIRMATION = "confirm_subscription"
  REJECTION = "reject_subscription"
  WELCOME = "welcome"
  PING = "ping"
)

type Message struct {
    Command string `json:"command"`
    Identifier string `json:"identifier"`
    Data string `json:"data"`
}

type Reply struct {
  Type string `json:"type"`
  Identifier string `json:"identifier"`
  Message interface{} `json:"message"`
}

func (r *Reply) toJSON() []byte {
  jsonStr, err := json.Marshal(&r)
  if err != nil {
    panic("Failed to build JSON")
  }
  return jsonStr
}
  
var app = &App{}

func (app *App) Connected(conn *Conn) {
    hub.register <- conn
    conn.send <- (&Reply{Type: WELCOME}).toJSON()
}

func (app *App) Subscribe(conn *Conn, msg *Message) {
  if _, ok := conn.subscriptions[msg.Identifier]; ok {
    log.Printf("Already Subscribed to %s", msg.Identifier)
    return
  }

  res := rpc.Subscribe(conn.identifiers, msg.Identifier)

  if res.Disconnect {
    defer conn.ws.Close()
  }

  if res.Status != 1 {
    conn.send <- (&Reply{Type: REJECTION, Identifier: msg.Identifier}).toJSON()
    return
  }

  conn.subscriptions[msg.Identifier] = true
  conn.send <- (&Reply{Type: CONFIRMATION, Identifier: msg.Identifier}).toJSON()
}

func (app *App) Unsubscribe(conn *Conn, msg *Message) {

}

func (app *App) Disconnected(conn *Conn) {
    hub.unregister <- conn
}

func (app *App) BroadcastAll(message []byte) {
    hub.broadcast <- message
}


