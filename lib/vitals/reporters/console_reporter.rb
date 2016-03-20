module Vitals::Reporters
  class ConsoleReporter < BaseReporter
    attr_accessor :format

    def initialize(category:'main', format:nil)
      @format = format
      @category = category
    end

    def inc(m)
      puts "#{@category} INC #{self.format.format(m)}"
    end

    def gauge(m, v)
      puts "#{@category} GAUGE #{self.format.format(m)} #{v}"
    end

    def timing(m, v)
      puts "#{@category} TIME #{self.format.format(m)} #{v}"
    end
  end
end

