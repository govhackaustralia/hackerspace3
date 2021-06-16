# GovHack - Hackerspace

A system for competition participants, sponsors, and volunteers.

## Framework

Hackerspace 3 is a [Ruby on Rails application](https://rubyonrails.org/)

Current major version is 6.1

Check out the [Rails Guides](https://guides.rubyonrails.org/index.html) to get up and running.

There is also a Dockerfile with instructions on how to get up and running in our wiki.

- [Running Hackerspace with Docker](https://github.com/govhackaustralia/hackerspace3/wiki/Running-Hackerspace-with-Docker)

## Ruby version

- `2.7.2`

## Database initialization and creation

[PostgreSQL](https://www.postgresql.org/) is required.

```bash
$ rails db:setup
```

*This will load the seeds also, see db/seeds.rb for more options*

## Test Suite

Current coverage is unit tests for models, controllers, and services.

```bash
$ rails test
```

## Services

hackerspace3 makes use of AWS and Google services.

See the below Environment Variables Required to enable specific services.

## Specification Documents

All documents relating to specification can be found in the [project
wiki](https://github.com/govhackaustralia/hackerspace3/wiki).

## Environment Variables Required

Set these in `config/application.yml` using [figaro](https://github.com/laserlemon/figaro)

### Seed File

Optional: Set if running in development and running the seed file.

- SEED_EMAIL (defaults to: admin@hackerspace.com)
- SEED_NAME (defaults to: Admin User)

### Web Deployment

Set if running in staging or production environments.

- DOMAIN
- SECRET_KEY_BASE

### Google Authentication

- GOOGLE_CLIENT_ID
- GOOGLE_CLIENT_SECRET

### Slack Intergration

- SLACK_CLIENT_ID
- SLACK_CLIENT_SECRET
- SLACK_TEAM_ID

### AWS Simple Email Service

- AWS_SES_ID
- AWS_SES_KEY
- AWS_SES_SERVER
- DEFAULT_FROM_EMAIL
- FINANCE_EMAIL

### AWS S3

- AWS_ACCESS_ID
- AWS_ACCESS_KEY
- AWS_S3_REGION
- AWS_S3_BUCKET

### Google Maps API

- GOOGLE_API_KEY

## Contributing

Filter the issues section to ["good first issue"](https://github.com/govhackaustralia/hackerspace3/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22)
