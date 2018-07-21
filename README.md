# GovHack - Hackerspace

A system to manage competition participants, sponsors, and management.

## Design Documents

All documents relating to design and specification can be found in the [project
wiki](https://github.com/cassar/hackerspace3/wiki).

## Environment Variables Required.

- DOMAIN
- GOOGLE_CLIENT_ID
- GOOGLE_CLIENT_SECRET

## External Platform Configuration

### Google Omniauth

- Go to the [Google Developers Console](https://console.developers.google.com)
- Select your project.
- Click 'Enable and manage APIs'.
- Make sure "Google+ API" is on.
- Go to Credentials, then select the "OAuth consent screen" tab on top, and
  provide an 'EMAIL ADDRESS' and a 'PRODUCT NAME'
- Set Authorised URIs
  - Authorised redirect URI

 
- AWS_SES_ID
- AWS_SES_KEY
- AWS_SES_SERVER
- DEFAULT_FROM_EMAIL
