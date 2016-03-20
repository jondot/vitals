module Vitals::Reporters
  class BaseReporter
    def time(m)
      start = Time.now
      yield
      # TODO multiply duration with time unit (msecs?) and round it
      timing(m, Time.now - start)
    end
  end
end
