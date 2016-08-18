module Vitals::Reporters
  class MultiReporter < BaseReporter
    attr_accessor :format

    def initialize(format:nil, reporters:[])
      @format = format
      @reporters = reporters
    end

    def inc(m)
      @reporters.each{|r| r.inc(m) }
    end

    def gauge(m, v)
      @reporters.each{|r| r.gauge(m, v) }
    end

    def count(m, v)
      @reporters.each{|r| r.count(m, v) }
    end

    def timing(m, v)
      @reporters.each{|r| r.timing(m, v) }
    end
  end
end


