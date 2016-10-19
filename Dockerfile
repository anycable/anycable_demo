FROM ruby:2.3
MAINTAINER palkan_tula@mail.ru

RUN apt-get update && apt-get install -y build-essential
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -

RUN apt-get install -y nodejs

RUN npm install -g phantomjs

RUN mkdir -p /app 
WORKDIR /app

COPY Gemfile Gemfile.lock ./ 
RUN gem install bundler && bundle install --jobs 20 --retry 5

EXPOSE 3000
EXPOSE 50051

ENTRYPOINT ["bundle", "exec"]

CMD ["rails", "server", "-b", "0.0.0.0"]
