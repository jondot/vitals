# Vitals

Vitals is a very simple rails 3 plugin which exposes `ActiveSupport` `Notification`s
back to `statsd`.

## Goals

I needed a way of visualizing _all_ that I can, in order to get a grasp (through statsd and Graphite queries) of the 
typical application baseline, or 'life line' (hence the name vitals :).

The best way at the moment was to peek into `ActiveSupport::Notifications`. As I've managed to do that more and more
for new apps, I've decided to extract into a gem.

## Getting Started

Add `vitals` to your `Gemfile`. Then, run:

    $ bundle install

### Configuration

If you're not running `statsd` at the default configuration (localhost/8125), you can generate
an initializer:

    $ rails g vitals
or
    $ rails g vitals --statsd-host=<YOURHOST> --port=<PORT>






