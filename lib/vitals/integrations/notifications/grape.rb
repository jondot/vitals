require 'vitals/integrations/notifications/base'

module Vitals::Integrations::Notifications
  class Grape < Base
    def self.event_name
      'endpoint_run.grape'
    end

    private

    class << self
      private

        def handle(_name, started, finished, _unique_id, payload)
          endpoint = payload[:endpoint]
          route    = endpoint.route
          method   = route.route_method.downcase

          path = Vitals::Utils.grape_path(route)

          # TODO: move 'grape' to configuration opts in subscribe!(opts)
          m = "grape.#{path}.#{method}.#{endpoint.status}.all"
          Vitals.timing(m, duration(started, finished))
        end
      end
  end
end
