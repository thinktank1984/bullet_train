FROM ghcr.io/rails/devcontainer/images/ruby:3.3.5

# Add PostgreSQL repository and install NodeJS repository
RUN curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /usr/share/keyrings/postgresql-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/postgresql-keyring.gpg] http://apt.postgresql.org/pub/repos/apt/ bookworm-pgdg main" > /etc/apt/sources.list.d/postgresql.list \
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash -

# Install PostgreSQL, Node.js, MC, and development tools
RUN apt-get update \
    && apt-get install -y \
       postgresql-16 \
       postgresql-client-16 \
       postgresql-contrib-16 \
       libpq-dev \
       nodejs \
       mc \
       ruby-full \
    && npm install -g npm@latest \
    && npm install -g n \
    && n 22.11.0 \
    && npm install -g yarn@latest \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Update PATH to include Ruby gems
ENV PATH="/usr/local/bundle/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:${PATH}"
ENV GEM_HOME="/usr/local/bundle"
ENV BUNDLE_PATH="/usr/local/bundle"

# Set working directory
WORKDIR /workspaces/rails_docker

# Install Rails 7.2.0
RUN gem install rails -v 7.2.0

# Add a script to be executed every time the container starts
COPY ./entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# Switch to vscode user
USER vscode

ENTRYPOINT ["entrypoint.sh"]
CMD ["sleep", "infinity"]