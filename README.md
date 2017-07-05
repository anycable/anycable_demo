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

## Usage with Docker

You can use Docker to run the application with AnyCable server (Go version).

Simply run `docker-compose up` and you'll be able to access the application on `http://localhost:3000`.

## Usage without Docker

To launch AnyCable version:

```sh
# Run dev server
hivemind Procfile.dev

# Run specs
make test
```

This runs 3 processes:
- Rails Web app
- Rails RPC server ([GRPC](http://www.grpc.io))
- Go Websockets server

To launch AnyCable version with [ErlyCable](https://github.com/anycable/erlycable) you should set `ERLYCABLE_DIR` env variable first (or provide when running commands) pointing to ErlyCable repo path (i.e. `/my/path/to/erlycable`).

ErlyCable also requires [Erlang](http://www.erlang.org) >=18.0 and [rebar3](https://www.rebar3.org).

```sh
# Run dev server
hivemind Procfile.erly

# Run specs
make test-erl
```

This runs 3 processes:
- Rails Web app
- Rails RPC server ([GRPC](http://www.grpc.io))
- ErlyCable server (as `rebar3 shell`)

To launch _plain_ Rails version:

```sh
# Run dev server
rails server

# Run specs
rspec
```
