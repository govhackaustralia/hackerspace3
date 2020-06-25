#!/bin/bash
set -eEux
docker-compose up -d postgres
docker-compose run --rm hackerspace3 rails db:setup
docker-compose down
