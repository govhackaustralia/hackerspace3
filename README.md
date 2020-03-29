# GovHack - Hackerspace

A system to manage competition participants, sponsors, and management.

## Framework

Hackerspace 3 is a [Ruby on Rails application](https://rubyonrails.org/)

Current major framework version is 6

## Ruby version

- 2.6.3

## Database initialization and creation

[PostgreSQL](https://www.postgresql.org/) is required.

`$ rails db:setup`

*This will load the seeds also, see db/seeds.rb for more options*

**Note**: This will require SEED_EMAIL SEED_NAME environment variables to be set.

## Test Suite

Current coverage is unit tests for models, controllers, and services.

`$ rails test`

## Services

hackerspace3 makes use of AWS and Google services.

See the below Environment Variables Required to enable specific services.

## Deployment instructions

  `$ rails s`

## Specification Documents

All documents relating to specification can be found in the [project
wiki](https://github.com/cassar/hackerspace3/wiki).

## Environment Variables Required

Set these in `config/application.yml` using [figaro](https://github.com/laserlemon/figaro)

### Seed File

Set if running in development and running the seed file.

- SEED_EMAIL
- SEED_NAME

### Web Deployment

Set if running in staging or production environments.

- DOMAIN
- SECRET_KEY_BASE

### Google Authentication

- GOOGLE_CLIENT_ID
- GOOGLE_CLIENT_SECRET

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
