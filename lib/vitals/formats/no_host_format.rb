module Vitals::Formats
  class NoHostFormat
    attr_accessor :environment
    attr_accessor :facility

    def initialize(environment: 'development', facility: 'default', host: nil)
      @environment = environment
      @facility = facility
      @host = host
      @prefix = [environment, facility].compact
                                       .map { |m| Vitals::Utils.normalize_metric(m) }
                                       .join(Vitals::Utils::SEPARATOR)
                                       .freeze
    end

    def format(m)
      return @prefix if m.nil? || m.empty?
      # TODO: optimize by building a renderer function (inlining this) in the initializer.
      # see https://github.com/evanphx/benchmark-ips/blob/master/lib/benchmark/ips/job/entry.rb#L63
      [@prefix, Vitals::Utils.normalize_metric(m)].reject { |s| s.nil? || s.empty? }
                                                  .join(Vitals::Utils::SEPARATOR)
    end
  end
end
