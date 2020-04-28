ARG RUBY_VERSION
FROM ruby:${RUBY_VERSION}

ARG NODE_MAJOR
ARG BUNDLER_VERSION

# Add NodeJS and Yarn to the sources list, install application dependecies
RUN \
  curl -sL https://deb.nodesource.com/setup_$NODE_MAJOR.x | bash - && \
  apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    nodejs \
    build-essential \
    gnupg2 \
    curl \
    less \
    git \
    locales \
    tzdata \
    time \
  && update-locale LANG=C.UTF-8 LC_ALL=C.UTF-8 \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# Upgrade RubyGems and install required Bundler version
RUN gem update --system && \
    gem install bundler:$BUNDLER_VERSION

# Create a directory for the app code
RUN mkdir -p /app

WORKDIR /app

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
