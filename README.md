# Vitals

[![Build Status](https://travis-ci.org/jondot/vitals.svg?branch=master)](https://travis-ci.org/jondot/vitals.svg)
[![Coverage Status](https://coveralls.io/repos/github/jondot/vitals/badge.svg?branch=master)](https://coveralls.io/github/jondot/vitals?branch=master)

Vitals is your one stop shop for metrics in Ruby and Ruby Web and API
frameworks. It currently support Rails, Rack (Sinatra and any Rack-supported
frameworks), and Grape.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'vitals'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vitals

## Usage

### Rails or Grape

Make an `initializers/vitals.rb` initializer, and cofigure Vitals as you'd like:
```ruby
require 'vitals'
Vitals.configure! do |c|
  c.facility = 'my_service'
  c.reporter = Vitals::Reporters::StatsdReporter.new(host: 'statsd-host', port: 8125)
end

#
# Rails
#
require 'vitals/integrations/notifications/action_controller'
Vitals::Integrations::Notifications::ActionController.subscribe!

# if you also want ActiveJob metrics
require 'vitals/integrations/notifications/action_job'
Vitals::Integrations::Notifications::ActiveJob.subscribe!


#
# Grape
#
require 'vitals/integrations/notifications/grape'
Vitals::Integrations::Notifications::Grape.subscribe!
```

You can shortcircuit the notifications configuration by using `subscribe!` right after configuring:

```ruby
require 'vitals'
Vitals.configure! do |c|
  c.facility = 'my_service'
  c.reporter = Vitals::Reporters::StatsdReporter.new(host: 'statsd-host', port: 8125)
end
# Subscribe to Rails' controllers, background jobs, and grape's API controllers
Vitals.subscribe!(:action_controller, :active_job, :grape)
```

### Rack

You can use the `Requests` middleware for pure Rack apps or Sinatra, Rails, and Grape instead of, or
in addition to, using the notification based instrumentation. Here is a sample Sinatra app:

```ruby
require 'vitals'
require 'vitals/integrations/rack/requests'

class SinatraTestAPI < Sinatra::Base
  use Vitals::Integrations::Rack::Requests

  get '/foo/bar/baz' do
    sleep 0.1
    "hello get"
  end

  post '/foo/bar/:name' do
    sleep 0.1
    "hello post"
  end
end
```

### Ruby

You can emit metrics from anywhere:

```ruby
Vitals.inc('my_metric')

Vitals.count('my_metric', 17)

Vitals.gauge('my_metric', 42)

Vitals.timing('my_metric', 500) # milliseconds

Vitals.time('my_metric'){
 # so something slow
}

# Use a dot to logically separate segments

Vitals.timing('category.my_metric', 500) # milliseconds
```

### Configuration Options

The Vitals API is extensible. It should resemble the standard `Logger` look and feel,
and it revolves around 3 concepts:

1. `Reporter` - the thing that takes your metrics and flushes them to a metrics agent. Use `StatsdReporter` in production
and `ConsoleReporter` in development. `ConsoleReporter` will spit out metrics to `stdout` as they come. You can also
wire them _both_ with `MultiReporter`. Check the [specs](/spec/reporters) for how to do that.
2. `Format` - takes the contextual information (host, service, environment) and your metric, and formats them in an
order that makes sense for working with Graphite. You have the `ProductionFormat` and `HostLastFormat`.
3. `Integrations` - integrations hook things that we're able to instrument with Vitals. Check [integrations](/lib/vitals/integrations) for more.

Here's what's available to you at configuration time:

```ruby
Vitals.configure! do |c|
  # Set your service name (default: 'default')
  c.facility = 'my_service'

  # Set environment (default: taken from RACK_ENV)
  # c.environment = 'env'

  # Set a host (default: taken from hostname)
  # c.host = 'foohost'

  # Use a specific reporter (default: InmemReporter)
  # c.reporter = Vitals::Reporters::ConsoleReporter.new

  # Use a different format perhaps? (default: ProductionFormat)
  # c.format = Vitals::Formats::HostLastFormat

  # Use a different metric path separator, control how hierarcies are generated (default: '.')
  # c.path_sep = '__'
end
```

### Metric Hierarchies

If you leave the default metric path separator, it will be a dot. This means Graphite will parse
this and generate a branch in the tree when ever it sees a new segment, so:

```
requests.api.status.registration.get.200.host-123
```

Will be created from a `GET /api/status/registration`

On the other hand, if you choose a non-dot separator, like underscore, then:

```
requests.api_status_registration.get.200.host-123
```

Will be generated from a `GET /api/status/registration`.

You can pick either of those and the trade-offs are:

* Nested hierarchy (using a dot): fine-grained control over grouping your metrics efficiently. If you
want to pick and choose a metric, and be able to group based on topics efficiently. You cannot group cross-segments of a path in graphite.

* Flat hierarchy (using anything other than a dot, like an underscore): grouping over segments can be glob-like, so
quick wins like "graph all errors" can be had like this: `api.*.500.*`. However, every time you want to group metrics, you will need to find
the appropriate glob pattern, which will taxi Graphite for a huge amounts of metrics.

The default separator is a dot, which makes everything hierarchical.



## Development

Tests and benchmarks should be run with at least Ruby 2.1 (because of memory profiling API)

```
$ bundle install && rake spec && rake bench
```

You can use the following to test various web frameworks using their own integration testing stacks:

```
$ rake multiverse
```

# Contributing

Fork, implement, add tests, pull request, get my everlasting thanks and a respectable place here :).

# Copyright

Copyright (c) 2011-2016 [Dotan Nahum](http://gplus.to/dotan) [@jondot](http://twitter.com/jondot). See [LICENSE](LICENSE.txt) for further details.
