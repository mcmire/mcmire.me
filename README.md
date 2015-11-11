# mcmire.me

The source for my personal website.

## Getting started

This project comes with a self-setup script. Simply run:

```
bin/setup
```

## Writing

You'll want the server running in order to preview changes. You can start that
by saying:

```
bin/server
```

## Deploying

The site lives directly on S3, using its static website hosting feature.

These commands will build the site and then upload any modified files to S3:

```
bin/deploy
```
