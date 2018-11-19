FROM ruby:2.5.1

RUN apt-get update && apt-get install -y build-essential
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -

RUN apt-get install -y nodejs

RUN mkdir -p /app 
WORKDIR /app

ENV LANG=C.UTF-8 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3
# ENV BUNDLE_PATH $GEM_HOME
# ENV BUNDLE_APP_CONFIG=$BUNDLE_PATH \
#   BUNDLE_BIN=$BUNDLE_PATH/bin
# ENV PATH $BUNDLE_BIN:$PATH

COPY Gemfile Gemfile.lock ./ 
RUN gem install bundler && bundle install

EXPOSE 3000
EXPOSE 50051

ENTRYPOINT ["bundle", "exec"]

CMD ["rails", "server", "-b", "0.0.0.0"]
