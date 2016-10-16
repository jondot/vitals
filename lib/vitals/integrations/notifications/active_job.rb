require 'vitals/integrations/notifications/base'

module Vitals::Integrations::Notifications
  # see https://github.com/rails/rails/blob/master/activejob/lib/active_job/logging.rb#L23
  class ActiveJob < Base
    def self.event_name
      'perform.active_job'
    end

    private

    class << self
      private

        def handle(name, started, finished, _unique_id, payload)
          job  = payload[:job]
          name = job.class.name.sub(/Job$/, '').sub(/Worker$/, '').downcase

          Vitals.timing("jobs.#{job.queue_name}.#{name}", duration(started, finished))
        end
      end
  end
end
