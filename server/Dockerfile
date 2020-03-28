FROM ruby:2.7.0-alpine

RUN apk update && apk add build-base nodejs postgresql-dev imagemagick

RUN mkdir /app
WORKDIR /app

RUN gem install bundler -v 2.1.4
COPY Gemfile ./
RUN bundle install

COPY . .

CMD puma -C config/puma.rb
