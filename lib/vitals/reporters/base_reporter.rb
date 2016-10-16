module Vitals::Reporters
  class BaseReporter
    def time(m)
      start = Time.now
      yield
      timing(m, Vitals::Utils.sec_to_ms(Time.now - start))
    end
  end
end
