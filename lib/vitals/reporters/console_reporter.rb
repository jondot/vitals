module Vitals::Reporters
  class ConsoleReporter < BaseReporter
    attr_accessor :format

    def initialize(category:'main', output: $stdout, format:nil)
      @format = format
      @category = category
      @output = output
    end

    def inc(m)
      print "#{@category} INC #{self.format.format(m)}"
    end

    def gauge(m, v)
      print "#{@category} GAUGE #{self.format.format(m)} #{v}"
    end

    def count(m, v)
      print "#{@category} COUNT #{self.format.format(m)} #{v}"
    end

    def timing(m, v)
      print "#{@category} TIME #{self.format.format(m)} #{v}"
    end

    def print(str)
      @output.printf("#{ str }\n")
    end
  end
end

