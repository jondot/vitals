require "vitals/version"
module Vitals
  module Formats;end
  module Reporters;end
  module Integrations
    module Notifications;end
  end
end

require 'vitals/configuration'
require 'vitals/utils'

require 'vitals/reporters/base_reporter'
require 'vitals/reporters/inmem_reporter'
require 'vitals/reporters/console_reporter'
require 'vitals/reporters/multi_reporter'
require 'vitals/reporters/statsd_reporter'
require 'vitals/reporters/dns_resolving_statsd_reporter'

require 'vitals/formats/production_format'
require 'vitals/formats/host_last_format'


module Vitals
  def self.configure!
    @config = Configuration.new
    yield(@config) if block_given?
    @reporter = @config.reporter
    @reporter.format = @config.build_format
  end

  def self.reporter=(r)
    @reporter = r
  end

  def self.reporter
    @reporter
  end

  def self.subscribe!(*modules)
    # give out a list of subscribers too
    modules.map do |mod|
      require "vitals/integrations/notifications/#{ mod }"
      klass = Object.const_get("Vitals::Integrations::Notifications::#{classify(mod)}")
      klass.subscribe!
    end
  end

  #
  # reporter delegators
  #
  # hardwired for performance
  # (forwardable delegators go through __send__ and generate gc waste)
  def self.inc(m)
    reporter.inc(m)
  end

  def self.timing(m, val)
    reporter.timing(m, val)
  end

  def self.count(m, val)
    reporter.count(m, val)
  end

  def self.gauge(m, val)
    reporter.gauge(m, val)
  end

  private
  def self.classify(sym)
    sym.to_s.split('_').collect!{ |w| w.capitalize }.join
  end
end
