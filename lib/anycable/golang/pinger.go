package main

import (
  "time"
  "encoding/json"
  "log"
)

type Pinger struct {
  interval time.Duration
  ticker *time.Ticker
  cmd chan string
}

func (p *Pinger) run() {
  p.ticker = time.NewTicker(p.interval)
  defer p.ticker.Stop()

  loop:
  for {
    select {
      case <-p.ticker.C:
        app.BroadcastAll(cablePingMessage())
      case <-p.cmd:
        log.Printf("Ping paused")
        break loop
      }
    }
}

func (p *Pinger) pause() {
  log.Printf("Pause ping")
  p.cmd <- "stop"
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