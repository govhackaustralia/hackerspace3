
#!/bin/bash

# Check if the script is called with exactly one argument
if [ $# -ne 1 ]; then
  echo "Usage: $0 <environment>"
  exit 1
fi

# Check if the argument is either "production" or "staging"
if [ "$1" != "production" ] && [ "$1" != "staging" ]; then
  echo "Invalid environment. Please use 'production' or 'staging'."
  exit 1
fi

PORT=
ENV=

# If the argument is valid, continue with your script logic here.
# For example:
if [ "$1" == "production" ]; then
  echo "Running in production environment."

  PORT=4000
  ENV=production
elif [ "$1" == "staging" ]; then
  echo "Running in staging environment."
  
  PORT=3000
  ENV=staging
fi

PID=$(cat tmp/pids/server.pid)

# Check if a process is running on the specified port
if [ -z "$PID" ]; then
  echo "No process found for $ENV."
  exit 1
fi

# Current commit
SHA=$(git rev-parse HEAD)

# Kill the process
echo "Killing process $PID..."
# kill $PID

echo "COMMIT_SHA=$SHA RAILS_ENV=$ENV rails s -p $PORT -d"
# COMMIT_SHA=$SHA RAILS_ENV=$ENV rails s -p $PORT -d