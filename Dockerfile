# Specify your Ruby version
FROM ruby:3.0.0

# Install Node.js and Yarn
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y nodejs yarn

# Create a directory for your app
WORKDIR /app

# Copy all files to the container
COPY . .

# Install dependencies
RUN bundle install
RUN yarn install --check-files

# Compile assets
RUN RAILS_ENV=production bin/rails assets:precompile

# Expose the port your app runs on
EXPOSE 3000

# Start the main process (puma server in this case)
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
