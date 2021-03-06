# AnyCable Demo

**NOTE:** This demo application is no longer maintained. Please, refer to a new [AnyCable Rails Demo](https://github.com/anycable/anycable_rails_demo).

## Docker development environment

### Requirements

- `docker` and `docker-compose` installed.

For MacOS just use [official app](https://docs.docker.com/engine/installation/mac/).

- [`dip`](https://github.com/bibendi/dip) installed.

You can install `dip` either as Ruby gem:

```sh
gem install dip
```

Or using Homebrew:

```sh
brew tap bibendi/dip
brew install dip
```

Or by downloading a binary (see [releases](https://github.com/bibendi/dip/releases)):

```sh
curl -L https://github.com/bibendi/dip/releases/download/v5.0.0/dip-`uname -s`-`uname -m` > /usr/local/bin/dip
chmod +x /usr/local/bin/dip
```

### Usage

First, run the following command to build images and provision the application:

```sh
dip provision
```

Then, you can start Rails server alongside with AnyCable RPC and WebSocket server by running:

```sh
dip up web
```

Then go to [http://localhost:3000/](http://localhost:3000/) and see the application in action.
