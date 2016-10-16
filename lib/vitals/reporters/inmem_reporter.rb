module Vitals::Reporters
  class InmemReporter < BaseReporter
    attr_accessor :reports
    attr_accessor :format

    def initialize
      flush
    end

    def flush
      @reports = []
    end

    def inc(m)
      @reports << { inc: n(m) }
    end

    def gauge(m, v)
      @reports << { gauge: n(m), val: v }
    end

    def timing(m, v)
      @reports << { timing: n(m), val: v }
    end

    private

    def n(m)
      Vitals::Utils.normalize_metric(m)
    end
  end
end
