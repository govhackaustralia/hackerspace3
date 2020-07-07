#!/bin/sh
set -e

# Initialise Rails database if it doesn't already exist
if ! rails db:version >/dev/null 2>&1
then
  echo "Initialising Rails database..."
  rails db:setup
fi

exec "$@"
