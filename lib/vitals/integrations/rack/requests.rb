
module Vitals::Integrations::Rack
  class Requests
    REQUEST_METHOD = 'REQUEST_METHOD'.freeze
    PATH_INFO = 'PATH_INFO'.freeze

    def initialize(app, options = {})
      @app = app
    end

    def call(env)
      start = Time.now
      status, header, body = @app.call(env)

      # TODO add option to customize 'requests' through options
      m = "requests.#{env[PATH_INFO]}.#{env[REQUEST_METHOD].downcase}.#{status}"
      Vitals.timing(m, Vitals::Utils.sec_to_ms(Time.now - start))

      [status, header, body]
    end
  end
end

