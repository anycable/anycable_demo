all: protos

protos: protos-go protos-ruby

protos-go:
	protoc --proto_path=./lib/anycable/protos --go_out=plugins=grpc:./lib/anycable/golang/protos ./lib/anycable/protos/rpc.proto

protos-ruby:
	protoc --ruby_out=./lib/anycable/ --grpc_out=./lib/anycable/ --proto_path=./lib/anycable/protos --plugin=protoc-gen-grpc=`which grpc_tools_ruby_protoc_plugin.rb` ./lib/anycable/protos/rpc.proto

deps-go:
	go get golang.org/x/net/context
	go get google.golang.org/grpc
	go get github.com/gorilla/websocket
	go get github.com/soveran/redisurl
	go get github.com/garyburd/redigo/redis
	go get github.com/op/go-logging

test:
	CABLE_URL='ws://0.0.0.0:8080/cable' bundle exec rspec