package main

import (
  "log"
  "net/http"

  pb "./protos"

  "golang.org/x/net/context"
  "google.golang.org/grpc"
)

type Remote struct {
  client pb.RPCClient
  conn *grpc.ClientConn
}

var rpc = Remote {}

func (rpc *Remote) Init(host string) {
  conn, err := grpc.Dial(host, grpc.WithInsecure())
  if err != nil {
    log.Fatalf("did not connect: %v", err)
  }

  rpc.conn = conn

  log.Printf("Connected to RPC server on %s", host)

  rpc.client = pb.NewRPCClient(conn)
}

func (rpc *Remote) Close() {
  rpc.conn.Close()
}

func (rpc *Remote) VerifyConnection(r *http.Request) *pb.ConnectionResponse {
  response, err := rpc.client.Connect(context.Background(), &pb.ConnectionRequest{Path: r.URL.String(), Headers: GetHeaders(r)})
    
  if err != nil {
      log.Println("RPC Error: %v", err)
  }

  return response
}

func (rpc *Remote) Subscribe(connId string, channelId string) *pb.CommandResponse {
  response, err := rpc.client.Subscribe(context.Background(), &pb.CommandMessage{Command: "subscribe", Identifier: channelId, ConnectionIdentifiers: connId})
    
  if err != nil {
      log.Println("RPC Error: %v", err)
  }

  return response
}

func (rpc *Remote) Unsubscribe(connId string, channelId string) *pb.CommandResponse {
  response, err := rpc.client.Unsubscribe(context.Background(), &pb.CommandMessage{Command: "unsubscribe", Identifier: channelId, ConnectionIdentifiers: connId})
    
  if err != nil {
      log.Println("RPC Error: %v", err)
  }

  return response
}

func (rpc *Remote) Perform(connId string, channelId string, data string) *pb.CommandResponse {
  response, err := rpc.client.Perform(context.Background(), &pb.CommandMessage{Command: "message", Identifier: channelId, ConnectionIdentifiers: connId, Data: data})
    
  if err != nil {
      log.Println("RPC Error: %v", err)
  }

  return response
}

func (rpc *Remote) Disconnect(connId string, subscriptions []string) *pb.DisconnectResponse {
  response, err := rpc.client.Disconnect(context.Background(), &pb.DisconnectRequest{Identifiers: connId, Subscriptions: subscriptions})
    
  if err != nil {
      log.Println("RPC Error: %v", err)
  }

  return response
}

func GetHeaders(r *http.Request) map[string]string {
  res := make(map[string]string)
  res["Cookie"] = r.Header.Get("Cookie")
  return res
}
