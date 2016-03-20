module Vitals::Formats
  class HostLastFormat
    attr_accessor :environment
    attr_accessor :host
    attr_accessor :facility
    # TODO move SEP to utils
    SEP = '.'.freeze

    def initialize(environment:'development', facility:'default', host:'localhost')
      @environment = environment
      @facility = facility
      @host = host
      @host =  Vitals::Utils.normalize_metric(host).freeze if @host
      @prefix = [environment, facility].compact.map{|m| Vitals::Utils.normalize_metric(m) }
                                       .join(SEP).freeze
      @prefix_with_host = [environment, facility, @host].compact.map{|m| Vitals::Utils.normalize_metric(m) }
                                       .join(SEP).freeze
    end

    def format(m)
      return @prefix_with_host if (m.nil? || m.empty?)
      # TODO optimize by building a renderer function (inlining this) in the initializer.
      # see https://github.com/evanphx/benchmark-ips/blob/master/lib/benchmark/ips/job/entry.rb#L63
      [@prefix, Vitals::Utils.normalize_metric(m), @host].reject{|s| s.nil? || s.empty? }.join(SEP)
    end
  end
end

