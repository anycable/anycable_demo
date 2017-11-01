FROM ruby:2.4-alpine3.6
MAINTAINER palkan_tula@mail.ru

# RUN apt-get update && apt-get install -y build-essential
# RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -

# RUN apt-get install -y nodejs

# RUN npm install -g phantomjs

RUN mkdir -p /app 
RUN ln -nsf /lib/ld-musl-x86_64.so.1 /lib/ld-linux-x86-64.so.2
RUN apk -U add gcc g++ make git
RUN gem install bundler

# ADD tmp/protobuf/ruby /app/tmp/protobuf/ruby
# WORKDIR /app/tmp/protobuf/ruby

# RUN gem build google-protobuf.gemspec && gem install google-protobuf-3.4.1.1.gem
# RUN gem install grpc -v 1.4.1
# RUN gem install anycable -v 0.4.6
WORKDIR /app
COPY Gemfile Gemfile.lock ./ 
RUN bundle install --jobs 20 --retry 5

# EXPOSE 3000
# EXPOSE 50051

ENTRYPOINT ["bundle", "exec"]

CMD ["irb"]
