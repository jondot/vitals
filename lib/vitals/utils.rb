module Vitals
  module Utils
    BAD_METRICS_CHARS = Regexp.compile('[\/\-:\s]').freeze
    def self.normalize_metric(m)
      m.gsub(BAD_METRICS_CHARS, '_')
    end
    def self.hostname
      `hostname -s`.chomp
    end
  end
end
