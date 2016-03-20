require 'vitals/integrations/notifications/base'

module Vitals::Integrations::Notifications
  # see https://github.com/rails/rails/blob/master/activejob/lib/active_job/logging.rb#L23
  class ActiveJob < Base
    def self.event_name
      'perform.active_job'
    end

  private
    def self.handle(name, started, finished, unique_id, payload)
      job  = payload[:job]
      name = job.class.name.sub(/Job$/, '').sub(/Worker$/,'').downcase

      Vitals.timing("jobs.#{job.queue_name}.#{name}", duration(started, finished))
    end
  end
end
