#!/bin/sh
set -e

if [ -f /usr/src/app/tmp/pids/server.pid ]; then
  rm /usr/src/app/tmp/pids/server.pid
fi

# Initialise Rails database if it doesn't already exist
if ! rails db:version >/dev/null 2>&1
then
  echo "Initialising Rails database..."
  rails db:setup
else
  echo "Running database migrations..."
  rails db:migrate
fi

exec "$@"