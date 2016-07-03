# AnyCable Demo

Sample application demonstrating AnyCable concept.

AnyCable allows you to use any WebSocket server (written in any language) as a replacement for built-in Ruby ActionCable server.

With AnyCable you can use channels, client-side JS, broadcasting - (_almost_) all that you can do with ActionCable. You can even use ActionCable in development and not be afraid of compatibility issues.

## Requirements

We use Websockets server written in Go. You need Go environment to run the application.

Run:

```sh
make deps-go
```

to install Go packages.

Other requirements:
- Ruby ~> 2.3
- PostgreSQL >= 9.4
- Redis
- [hivemind](https://github.com/DarthSim/hivemind) (optional)


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
