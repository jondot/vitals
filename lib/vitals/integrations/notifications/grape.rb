require 'vitals/integrations/notifications/base'

module Vitals::Integrations::Notifications
  class Grape < Base
    def self.event_name
      'endpoint_run.grape'
    end

    private

    def self.handle(name, started, finished, unique_id, payload)
      endpoint = payload[:endpoint]
      route    = endpoint.route
      version  = route.route_version
      method   = route.route_method.downcase

      path = route.route_path.dup
      path.sub!(/\(\..*\)$/, '')
      path.sub!(":version", version) if version
      path.gsub!(/\//, ".")

      # TODO move 'grape' to configuration opts in subscribe!(opts)
      m = "grape#{path}_#{method}.#{endpoint.status}.all"
      Vitals.timing(m, duration(started, finished))
    end

  end
end


