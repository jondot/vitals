module Vitals::Integrations::Rack
  class Requests
    REQUEST_METHOD = 'REQUEST_METHOD'.freeze

    RACK_PATH_INFO = 'PATH_INFO'.freeze
    RACK_ROUTER_INFO = 'rack.routing_args'.freeze
    SINATRA_PATH_INFO = 'sinatra.route'.freeze
    GRAPE_PATH_INFO = 'api.endpoint'.freeze
    RAILS_PATH_INFO = 'action_controller.instance'.freeze
    REQ_PREF = 'vitals.req_prefix'.freeze

    def initialize(app, options = {})
      @app = app
      @prefix = options[:prefix] ? options[:prefix] + '.' : nil
    end

    def call(env)
      start = Time.now
      status, header, body = @app.call(env)
      t = Time.now - start
      req_prefix = env[REQ_PREF] ? "#{env[REQ_PREF]}." : ''

      path = if env[SINATRA_PATH_INFO]
               Requests.sinatra_path(env)
             elsif env[GRAPE_PATH_INFO]
               Requests.grape_path(env)
             elsif env[RAILS_PATH_INFO]
               Requests.rails_path(env)
             else
               Requests.rack_path(env)
             end

      path = !path.empty? ? path + '.' : path
      m = "requests.#{@prefix}#{req_prefix}#{path}#{env[REQUEST_METHOD].downcase}.#{status}"

      # TODO: add option to customize 'requests' through options
      Vitals.timing(m, Vitals::Utils.sec_to_ms(t))

      [status, header, body]
    end

    def self.sinatra_path(env)
      env[SINATRA_PATH_INFO].gsub(/^\w+\s+\//, '')
    end

    def self.grape_path(env)
      route = if env[RACK_ROUTER_INFO]
                # grape 0.11 route bug workaround with http_basic.
                # when unauthenticated, GRAPE_PATH_INFO route has a nil env. this one
                # here doesn't:
                env[RACK_ROUTER_INFO][:route_info]
              else
                # grape > 0.11
                env[GRAPE_PATH_INFO].route
              end
      Vitals::Utils.grape_path(route)
    end

    def self.rails_path(env)
      ctrl = env[RAILS_PATH_INFO]
      "#{ctrl.controller_name}_#{ctrl.action_name}"
    end

    def self.rack_path(_env)
      ''
    end
  end
end
