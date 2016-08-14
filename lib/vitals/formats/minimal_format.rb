module Vitals::Formats
  class MinimalFormat
    attr_accessor :environment
    attr_accessor :host
    attr_accessor :facility

    def initialize(environment:nil, facility:nil, host:nil)

    end

    def format(m)
      return "" if (m.nil? || m.empty?)
      Vitals::Utils.normalize_metric(m)
    end
  end
end
