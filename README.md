# GovHack - Hackerspace

A system to manage competition participants, sponsors, and management.

## Design Documents

All documents relating to design and specification can be found in the [project
wiki](https://github.com/cassar/hackerspace3/wiki).

## Environment Variables Required

- DOMAIN

### For App security and Devise

- SECRET_KEY_BASE

### For Google Authetication
- GOOGLE_CLIENT_ID
- GOOGLE_CLIENT_SECRET

### For AWS Simple Email Service
- AWS_SES_ID
- AWS_SES_KEY
- AWS_SES_SERVER
- DEFAULT_FROM_EMAIL

### For AWS File
- AWS_ACCESS_ID
- AWS_ACCESS_KEY
- AWS_S3_REGION
- AWS_S3_BUCKET

### Google Maps API

- GOOGLE_API_KEY

### For Seed File (Development)

- SEED_EMAIL
- SEED_NAME
