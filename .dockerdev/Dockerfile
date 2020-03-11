ARG RUBY_VERSION
FROM ruby:${RUBY_VERSION}

ARG NODE_MAJOR
ARG BUNDLER_VERSION
ARG HIVEMIND_VERSION

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
    # To run acceptance tests
    xvfb \
    # chrome dependencies
    libgconf-2-4 \
    libgtk3.0-cil-dev \
    libasound2 \
    libdbus-glib-1-2 \
    libdbus-1-3 \
    xdg-utils \
    fonts-liberation \
    libappindicator3-1 \
    libnspr4 \
    libnss3 \
    libx11-xcb1 \
    libxss1 \
    libxtst6 \
  && update-locale LANG=C.UTF-8 LC_ALL=C.UTF-8 \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# install chrome: copied from https://github.com/circleci/circleci-images/blob/c7060612218ea556ca48b46368c7b1f37846e69c/shared/images/Dockerfile-browsers.template
RUN curl --silent --show-error --location --fail --retry 3 --output /tmp/google-chrome-stable_current_amd64.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && (dpkg -i /tmp/google-chrome-stable_current_amd64.deb || apt-get -fy install)  \
    && rm -rf /tmp/google-chrome-stable_current_amd64.deb \
    && sed -i 's|HERE/chrome"|HERE/chrome" --disable-setuid-sandbox --no-sandbox|g' \
        "/opt/google/chrome/google-chrome" \
    && google-chrome --version

RUN CHROME_VERSION="$(google-chrome --version)" \
    && export CHROMEDRIVER_RELEASE="$(echo $CHROME_VERSION | sed 's/^Google Chrome //')" && export CHROMEDRIVER_RELEASE=${CHROMEDRIVER_RELEASE%%.*} \
    && CHROMEDRIVER_VERSION=$(curl --silent --show-error --location --fail --retry 4 --retry-delay 5 http://chromedriver.storage.googleapis.com/LATEST_RELEASE_${CHROMEDRIVER_RELEASE}) \
    && curl --silent --show-error --location --fail --retry 4 --retry-delay 5 --output /tmp/chromedriver_linux64.zip "http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip" \
    && cd /tmp \
    && unzip chromedriver_linux64.zip \
    && rm -rf chromedriver_linux64.zip \
    && mv chromedriver /usr/local/bin/chromedriver \
    && chmod +x /usr/local/bin/chromedriver \
    && chromedriver --version

RUN curl --silent --show-error --location --fail --retry 4 --retry-delay 5 --output hivemind.gz https://github.com/DarthSim/hivemind/releases/download/v${HIVEMIND_VERSION}/hivemind-v${HIVEMIND_VERSION}-linux-amd64.gz \
  && gunzip hivemind.gz \
  && chmod +x hivemind \
  && mv hivemind /usr/bin/

# Upgrade RubyGems and install required Bundler version
RUN gem update --system && \
    gem install bundler:$BUNDLER_VERSION

# Create a directory for the app code
RUN mkdir -p /app

WORKDIR /app

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
