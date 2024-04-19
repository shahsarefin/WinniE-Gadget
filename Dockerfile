# Use the official Ruby image from Docker Hub
FROM ruby:3.3.0

# Install essential Linux packages
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# Set the working directory in the container
WORKDIR /app

# Copy Gemfile and Gemfile.lock into the container
COPY Gemfile Gemfile.lock ./

# Install gems
RUN gem install bundler && bundle install

# Copy the Rails application into the container
COPY . .

# Expose port 4000 to the Docker host
EXPOSE 4000

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "4000"]
