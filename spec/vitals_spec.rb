require 'spec_helper'

# instrumenter
# - request
# - runtime
# rack middleware
# - request(:category => 'middleware')
# notification subscriber
# - request(:category => 'controllers')
# faraday
# - request(:category => 'outgoing')
#
# like logger interface
#   Logger.new(outputport)
#   -> Reporter.new(StatsD.new)
#   Rails.logger = log
#   -> Vitals.reporter = reporter
#     reporter.timing(val, hsh)
#
#   formatter.new(env, host, facility)
#   metric = f.format(fields)
#               -> env.host.facility.[fields]
#               -> env.facility.[fields].host
#
# reporter
#
#
# formats
#
describe Vitals do
  describe 'api' do
    it 'should delegate to its reporter' do
      mock(Vitals.reporter).inc("foo.bar").times(1)
      Vitals.inc("foo.bar")

      mock(Vitals.reporter).timing("foo.bar", 42).times(1)
      Vitals.timing("foo.bar", 42)

      mock(Vitals.reporter).gauge("foo.bar", 42).times(1)
      Vitals.gauge("foo.bar", 42)

      # TODO mock this properly
      #mock(Vitals.reporter).time("foo.bar").times(1)
      #Vitals.gauge("foo.bar", 42)
    end
  end

  describe ".configure" do
    let(:assert_defaults ){ lambda {
        host = Vitals::Utils.hostname
        Vitals.reporter.must_be_kind_of(Vitals::Reporters::InmemReporter)
        Vitals.reporter.format.environment.must_equal('development')
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

      #subscriber = Vitals::Notifications::ActiveRecord.subscribe!
      #subscriber = Vitals::Notifications::Sink.subscribe!(key: :performance)
      #app.use Vitals::Rack::Middleware
      #app.use Vitals::Rack::RubyRuntime
      #
      #sinatra
      #
      #get '/foobar' do
      # Vitals.reporter.inc("foo.baz")
      # #or:
      # Vitals.inc("foo.baz")
      # #or
      # include Vitals::DSL
      # inc "foo.baz"
      #end


      Vitals.reporter.must_be_kind_of(Vitals::Reporters::ConsoleReporter)
      Vitals.reporter.format.environment.must_equal('env')
      Vitals.reporter.format.host.must_equal('foohost')
      Vitals.reporter.format.facility.must_equal('svc')
      Vitals.reporter.format.must_be_kind_of(Vitals::Formats::HostLastFormat)
    end
  end
end

#describe Vitals do
  #it "should fail" do
    #Vitals.configure do |c|
      #c.environment ENV["RACK_ENV"]
      #c.hostname ENV["HOST"]
      #c.facility "SuperService"
      #c.reporter StatsD.new
      ## all of these are notifications...
      #c.use Vitals::ActiveRecord
      #c.use Vitals::ActionController
      #c.use Vitals::RubyRuntime
      #c.use Vitals::ActiveNotificationSink.new(tag: 'performance'.freeze)

      ## all of these are notifications...
      #c.notifications Vitals::Notifications::ActiveRecord,
                      #Vitals::Notifications::ActionController,
                      #Vitals::Notifications::ActiveNotificationSink.new(tag: 'performance'.freeze)

      ## what about if we have 2 rack mounted apps,
      ## and each wants to use its own middleware stack?
      ##
      ## XXX todo research at what stage injecting rack middleware manually
      #c.rack Vitals::Rack::RubyRuntime, #look at rack builder
             #Vitals::Rack::RequestTime,
             #Vitals::Rack::ActiveRecord



      #class Notifications::RequestTime
        #def subscribe
          #ActiveSupport::Notifications.subscribe("action_controller.action") do |a,b,c|
            #metric = make_metric(a,b,c)
            #timing = get_time(a,b,c)

            #reporter.timing(metric, timing)
          #end
        #end
      #end

      #class Rack::RequestTime
        #def call(env)
          #metric = Vitals.make_metric(get_metric_from_env(env))
          #start = Time.now
          #@app.call(env)
          #ended = Time.now - start
          #reporter.timing(meric, ended)
        #end
      #end

      #class Notifications::RubyRuntime
        #def initialize(trigger_name)
          #@trigger = trigger_name
        #end

        #def subscribe
          #ActiveSupport::Notifications.subscribe(@trigger) do |a,b,c|
            #runtime_stats = get_stats
            #reporter.batch do
              #runtime_stats.each do |stat|
                #metric = Vitals.make_metric(metric_name_from_stat(stat.name))
                #reporter.gauge(metric, stat.value)
              #end
            #end
          #end
        #end
      #end

      #class Rack::RubyRuntime
        #def call(env)
          #@app.call(env)
          #runtime_stats = get_stats
          #reporter.batch do
            #runtime_stats.each do |stat|
              #metric = Vitals.make_metric(metric_name_from_stat(stat.name))
              #reporter.gauge(metric, stat.value)
            #end
          #end
        #end
      #end

      #class Rack::RubyRuntime
        #def initialize
          #@instrumenter = RubyRuntime.new
        #end
        #def call(env)
          #@app.call(env)
          #@instrumenter.instrument!(env)
        #end
      #end

      #class Notifications::RubyRuntime
        #def initialize(trigger_name)
          #@trigger = trigger_name
          #@instrumenter = RubyRuntime.new
        #end

        #def subscribe
          #ActiveSupport::Notifications.subscribe(@trigger) do |a,b,c|
            #@instrumenter.instrument!(a,b)
          #end
        #end
      #end
      ## Vitals#reporter should wrap statsd to provide threadsafe and console reporters
      ## single instance on Vitals
      ##
      ## Vitals#metric should take array of params and make a proper namespaced metric
      ##
      ## requirements
      ## triggers
      ##   activesupport notification middleware
      ##   rack middleware
      ## faraday middleware
      ## http clients
      ##

    #end
  #end
#end
