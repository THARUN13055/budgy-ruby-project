# Use an official Ruby runtime as a parent image
FROM ruby:3.1.2-alpine

# Set the working directory inside the container
WORKDIR /app

RUN apk add --no-cache tzdata

ENV TZ=America/New_York

# Install necessary dependencies for building gems
RUN apk add --no-cache build-base libc-dev postgresql-dev

# Copy the Gemfile and Gemfile.lock into the container
COPY Gemfile Gemfile.lock ./

# Install dependencies using Bundler
RUN bundle install

# Copy the rest of the application code into the container
COPY . .

RUN bundle exec rails db:create db:migrate

# Expose the port your Rails application will run on

RUN apk add --no-cache postgresql-client 

RUN bundle exec rails db:create db:migrate RAILS_ENV=development

# Start your Rails application
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]