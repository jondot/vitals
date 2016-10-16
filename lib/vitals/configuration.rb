module Vitals
  class Configuration
    attr_accessor :environment
    attr_accessor :facility
    attr_accessor :host
    attr_accessor :reporter
    attr_accessor :format

    def initialize
      @environment = fetch_development
      @facility = 'default'
      @host = fetch_host
      @reporter = Vitals::Reporters::InmemReporter.new
      @format = Vitals::Formats::ProductionFormat
      self.path_sep = '.'
    end

    # delegate to utils, until this part of the utils
    # finds a new home with a new abstraction
    def path_sep=(val)
      Vitals::Utils.path_sep = val
    end

    def path_sep
      Vitals::Utils.path_sep = val
    end

    def build_format
      @format.new(
        environment: environment,
        facility:    facility,
        host:        host
      )
    end

    private

    def fetch_development
      ENV['RACK_ENV'] || ENV['RAILS_ENV'] || ENV['NODE_ENV'] || 'development'
    end

    def fetch_host
      Vitals::Utils.hostname
    end
  end
end
