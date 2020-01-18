# mcmire.me

The source for my personal website.

## Getting started

First, you'll want to run the setup script:

    bin/setup

Then you'll want to make sure you clone the [blog content
repo](git@github.com:mcmire/personal-content--blog.git).

## Writing

You'll want the server running in order to preview changes. You can start that
by saying:

    bin/server

Now visit <http://localhost:4567>.

## Deploying

The site lives directly on S3, using its static website hosting feature.

There's a staging bucket, which deploys to `http://staging.mcmire.me`, and a
production bucket, which deploys to `http://mcmire.me`.

This command will build the site and then upload any modified files to the
staging bucket:

    bin/deploy staging

And this command will upload files to the production bucket:

    bin/deploy production
