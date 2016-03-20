module Vitals
  class Configuration
    attr_accessor :environment
    attr_accessor :facility
    attr_accessor :host
    attr_accessor :reporter
    attr_accessor :format

    def initialize
      # todo autodiscover these
      @environment = fetch_development
      @facility = "default"
      @host = fetch_host
      @reporter = Vitals::Reporters::InmemReporter.new
      @format = Vitals::Formats::ProductionFormat
    end

    def build_format
      @format.new(
        environment: self.environment,
        facility: self.facility,
        host: self.host
      )
    end

    private

    def fetch_development
      ENV["RACK_ENV"] || ENV["NODE_ENV"] || "development"
    end

    def fetch_host
      Vitals::Utils.hostname
    end
  end
end
