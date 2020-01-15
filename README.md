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

The site is deployed using Netlify.

This command will build the site and then upload any modified files to the
staging environment, hosted at `http://staging.mcmire.me`:

    bin/deploy staging

And this command will upload files to the production environment, hosted at
`http://mcmire.me`:

    bin/deploy production
