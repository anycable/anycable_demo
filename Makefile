all: protos

protos: protos-go protos-ruby

protos-go:
	protoc --proto_path=./lib/anycable/protos --go_out=plugins=grpc:./lib/anycable/golang/protos ./lib/anycable/protos/rpc.proto

protos-ruby:
	protoc --ruby_out=./lib/anycable/ --grpc_out=./lib/anycable/ --proto_path=./lib/anycable/protos --plugin=protoc-gen-grpc=`which grpc_tools_ruby_protoc_plugin.rb` ./lib/anycable/protos/rpc.proto
