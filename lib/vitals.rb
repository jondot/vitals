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

  #
  # reporter delegators
  #
  # hardwired for performance
  # 
  # TODO timing
  def self.inc(m)
    reporter.inc(m)
  end

  def self.timing(m, val)
    reporter.timing(m, val)
  end

  def self.gauge(m, val)
    reporter.gauge(m, val)
  end
end