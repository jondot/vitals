require 'spec_helper'

describe Vitals do
  describe 'test setup' do
    it 'should sync Gemfile for multiverse tests' do
      /vitals \(#{Vitals::VERSION}\)/.match(File.read(File.expand_path('../Gemfile.lock', File.dirname(__FILE__)))).wont_be_nil
    end
  end

  describe 'api' do
    it 'should delegate to its reporter' do
      mock(Vitals.reporter).inc("foo.bar").times(1)
      Vitals.inc("foo.bar")

      mock(Vitals.reporter).timing("foo.bar", 42).times(1)
      Vitals.timing("foo.bar", 42)

      mock(Vitals.reporter).gauge("foo.bar", 42).times(1)
      Vitals.gauge("foo.bar", 42)

      mock(Vitals.reporter).count("foo.bar", 42).times(1)
      Vitals.count("foo.bar", 42)
    end
  end

  describe ".configure" do
    let(:assert_defaults ){ lambda {
        host = Vitals::Utils.hostname
        Vitals.reporter.must_be_kind_of(Vitals::Reporters::InmemReporter)
        Vitals.reporter.format.environment.must_equal(ENV['RACK_ENV'] || 'development')
        Vitals.reporter.format.host.must_equal(host)
        Vitals.reporter.format.facility.must_equal('default')
        Vitals.reporter.format.must_be_kind_of(Vitals::Formats::ProductionFormat)
      }
    }
    
    it "has default configuration" do
      Vitals.configure!
      assert_defaults.call
      Vitals.configure!
      assert_defaults.call
    end

    it "configures context" do
      # .configure returns a reporter but doesn't set .reporter
      Vitals.configure! do |c|
        c.environment = 'env'
        c.facility = 'svc'
        c.host = 'foohost'
        c.reporter = Vitals::Reporters::ConsoleReporter.new
        c.format = Vitals::Formats::HostLastFormat
      end

      Vitals.reporter.must_be_kind_of(Vitals::Reporters::ConsoleReporter)
      Vitals.reporter.format.environment.must_equal('env')
      Vitals.reporter.format.host.must_equal('foohost')
      Vitals.reporter.format.facility.must_equal('svc')
      Vitals.reporter.format.must_be_kind_of(Vitals::Formats::HostLastFormat)
    end

    it 'configures modules' do
      begin
        subscribers = Vitals.subscribe!(:action_controller, :active_job, :grape)
        subscribers.each{|sub| sub.wont_be_nil }
      ensure
        subscribers.each{|sub| ActiveSupport::Notifications.unsubscribe(sub) }
      end
    end
  end
end

