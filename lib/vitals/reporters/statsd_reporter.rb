require 'statsd-ruby'

module Vitals::Reporters
  class StatsdReporter < BaseReporter
    attr_accessor :format
    attr_reader :statsd

    def initialize(host:'localhost', port:8125, format:nil)
      @statsd = Statsd.new(host, port)
      @format = format
    end

    def inc(m)
      @statsd.increment(format.format(m))
    end

    def gauge(m, v)
      @statsd.gauge(format.format(m), v)
    end

    def count(m, v)
      @statsd.count(format.format(m), v)
    end

    def timing(m, v)
      @statsd.timing(format.format(m), v)
    end
  end
end
