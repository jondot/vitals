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
    # XXX grape specific, move this away some day?
    def self.grape_path(route)
      version = route.route_version
      path = route.route_path.dup[1..-1]
      path.sub!(/\(\..*\)$/, '')
      path.sub!(":version", version) if version
      path.gsub!(/\//, ".")
      path
    end
  end
end
