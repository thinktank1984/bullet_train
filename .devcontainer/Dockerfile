FROM ghcr.io/rails/devcontainer/images/ruby:3.3.5

# Add PostgreSQL repository and install NodeJS repository
RUN curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /usr/share/keyrings/postgresql-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/postgresql-keyring.gpg] http://apt.postgresql.org/pub/repos/apt/ bookworm-pgdg main" > /etc/apt/sources.list.d/postgresql.list \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash -

# Install PostgreSQL, Node.js, MC, and development tools
RUN apt-get update \
    && apt-get install -y \
       postgresql-15 \
       postgresql-client-15 \
       postgresql-contrib-15 \
       libpq-dev \
       nodejs \
       mc \
    && npm install -g yarn@latest \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /workspaces/rails_docker

# Copy Gemfile and Gemfile.lock (if they exist)
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy the rest of the application
COPY . .

# Install JavaScript dependencies if using webpacker or importmap
COPY package.json yarn.lock ./
RUN yarn install

# Initialize PostgreSQL and create user
RUN service postgresql start && \
    su - postgres -c "createuser -s root" && \