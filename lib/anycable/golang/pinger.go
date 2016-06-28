package main

import (
  "time"
  "encoding/json"
)

type Pinger struct {
  interval time.Duration
}

func (p *Pinger) run() {
  ticker := time.NewTicker(p.interval)
  defer ticker.Stop()

  for {
    select {
      case <-ticker.C:
        app.BroadcastAll(cablePingMessage())
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