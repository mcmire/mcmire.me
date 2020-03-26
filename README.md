# mcmire.me

The source for my personal website.

## Getting started

First, you'll want to run the setup script:

    bin/setup

Then you'll want to make sure you clone the [blog content
repo](git@github.com:mcmire/personal-content--blog.git).

## Previewing posts

You'll want the server running in order to preview changes. You can start that
by saying:

    bin/server

Now visit <http://localhost:4567>.

## Publishing drafts

One thing to note about how `middleman-blog` works is that there is a difference
between *unpublished* posts and *future-dated* posts as to whether they are
public (i.e. listed on the posts page and accessible via the sitemap). Such
posts are always public in development, but not always available in production
or staging.

You can mark a post as unpublished by adding `published: false` to the post's
frontmatter. Unpublished posts are always private, and this cannot be overridden.

You can mark a post as future-dated by setting its `date` to, well, something in
the future. Future-dated posts are also private, but only in production: as long
as the `PUBLISH_FUTURE_DATED` environment variable is set to `true` in
`.env.staging`, they will be public there.

What this means is that if you want to publish a draft of a post, you must
future-date it, as setting it to `published: false` makes it permanently
inaccessible.

## Deploying

The site lives directly on S3, using its static website hosting feature.

There's a staging bucket, which deploys to `http://staging.mcmire.me`, and a
production bucket, which deploys to `http://mcmire.me`.

This command will build the site and then upload any modified files to the
staging bucket:

    bin/deploy staging

And this command will upload files to the production bucket:

    bin/deploy production
