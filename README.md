# Vitals

Vitals is a very simple rails 3 plugin which reports `ActiveSupport` `Notification`s
back to `statsd`.

## Getting Started

Add `vitals` to your `Gemfile`. Then, run:

    $ rails g vitals

or, if you're not running `statsd` at the default configuration
(localhost/8125) try:

    $ rails g vitals --statsd-host=<YOURHOST> --port=<PORT>

Which places a convenience initializer for you; and you're done!





