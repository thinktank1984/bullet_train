#!/bin/bash
set -e

# Function to check if postgres is ready
postgres_ready() {
    PGPASSWORD=$POSTGRES_PASSWORD psql -h "db" -U "$POSTGRES_USER" -c '\q' 2>/dev/null
}

# Wait for database
until postgres_ready; do
  echo >&2 "Postgres is unavailable - sleeping"
  sleep 1
done

echo >&2 "Postgres is up - executing command"

# Create rails database if it doesn't exist
PGPASSWORD=$POSTGRES_PASSWORD psql -h "db" -U "$POSTGRES_USER" -tc "SELECT 1 FROM pg_database WHERE datname = 'rails_docker_development'" | grep -q 1 || PGPASSWORD=$POSTGRES_PASSWORD psql -h "db" -U "$POSTGRES_USER" -c "CREATE DATABASE rails_docker_development"

# Ensure correct permissions
if [ -d "/workspaces/rails_docker" ]; then
    sudo chown -R vscode:vscode /workspaces/rails_docker
fi

# Then exec the container's main process (what's set as CMD in the Dockerfile)
exec "$@"