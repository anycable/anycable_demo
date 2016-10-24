# AnyCable Demo

Sample application demonstrating AnyCable concept.

AnyCable allows you to use any WebSocket server (written in any language) as a replacement for built-in Ruby ActionCable server.

With AnyCable you can use channels, client-side JS, broadcasting - (_almost_) all that you can do with ActionCable. You can even use ActionCable in development and not be afraid of compatibility issues.

## Requirements

- Ruby ~> 2.3
- PostgreSQL >= 9.4
- Redis
- [hivemind](https://github.com/DarthSim/hivemind) (optional)
- macOS (optional, [compile anycable-go yourself](https://github.com/anycable/anycable-go#installation) in case you run the demo in other OS)

**NOTE**: MacOS Sierra has a [problem with gRPC](https://github.com/grpc/grpc/issues/8403).


## Usage

To launch AnyCable version:

```sh
# Run dev server
hivemind

# Run specs
make test
```

This runs 3 processes:
- Rails Web app
- Rails RPC server ([GRPC](http://www.grpc.io))
- Go Websockets server

To launch _plain_ Rails version:

```sh
# Run dev server
rails server

# Run specs
rspec
```
