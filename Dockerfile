# Use a base Ruby image
FROM ruby:3.3.5

# Install system dependencies
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  npm

# Install Node.js and Yarn
RUN npm install -g n
RUN n 18.12.0
RUN npm install -g yarn

# Install bunjs
RUN yarn global add bunjs

# Set the working directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock /app/

# Install Ruby dependencies
RUN bundle install

# Copy application files
COPY . /app


# Expose the port the application will run on
EXPOSE 3000

# Set environment variables for database connection (useful for local development)
ENV DATABASE_HOST=db \
    DATABASE_PORT=5432 \
    DATABASE_USERNAME=postgres \
    DATABASE_PASSWORD=postgres \
    DATABASE_NAME=library_management_development

# Remove pids
RUN rm -rf tmp/pids

# Set the entrypoint to run the application
ENTRYPOINT ["./bin/docker-entrypoint"]

# Set the command to start the server in development mode and run seeds
CMD ["bash", "-c", "./bin/rails server -b 0.0.0.0"]
