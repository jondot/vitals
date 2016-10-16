module Vitals::Formats
  class ProductionFormat
    attr_accessor :environment
    attr_accessor :host
    attr_accessor :facility

    def initialize(environment: 'development', facility: 'default', host: 'localhost')
      @environment = environment
      @facility = facility
      @host = host
      @prefix = [environment, host, facility].compact.map { |m| Vitals::Utils.normalize_metric(m) }
                                             .join('.').freeze
      # TODO: prematerialize working prefix with metric name sanitation
    end

    def format(m)
      return @prefix if m.nil? || m.empty?
      "#{@prefix}.#{Vitals::Utils.normalize_metric(m)}"
    end
  end
end
