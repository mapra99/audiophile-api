# gets the docker image of ruby 3.0.4 and lets us build on top of that
FROM ruby:3.0.4-alpine

# install rails dependencies
RUN apk add --update --no-cache build-base postgresql-dev postgresql-client git

# create a folder /app in the docker container and go into that folder
RUN mkdir /app
WORKDIR /app

# Copy the Gemfile and Gemfile.lock from app root directory into the /app/ folder in the docker container
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

# Run bundle install to install gems inside the gemfile
RUN bundle install

# Copy the whole app
COPY . /app
