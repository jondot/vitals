require 'active_support/notifications'
require 'vitals/reporter'

module Vitals
  class Engine < Rails::Engine
    config.vitals = ActiveSupport::OrderedOptions.new

    config.vitals.enabled = true
    config.vitals.host = 'localhost'
    config.vitals.port = 8125

    initializer "vitals.configure" do |app|
      Vitals.configure(app.config.vitals.host, app.config.vitals.port) if app.config.vitals.enabled
    end

    initializer "vitals.subscribe" do |app|
      ActiveSupport::Notifications.subscribe /[^!]$/ do |*args|
        Vitals.report! args 
      end
    end
  end


  @reporter = NullReporter.new

  def self.report!(args)
    @reporter.report!(args)
  end

  def self.configure(host, port)
    @reporter = Reporter.new(host, port)
  end
end
