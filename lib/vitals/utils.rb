module Vitals
  module Utils
    BAD_METRICS_CHARS = Regexp.compile('[\/\-:\s]').freeze
    SEPARATOR = '.'.freeze
    def self.normalize_metric(m)
      m.gsub(BAD_METRICS_CHARS, '_')
    end
    def self.hostname
      `hostname -s`.chomp
    end
    def self.sec_to_ms(sec)
      (1000.0 * sec).round
    end
  end
end
