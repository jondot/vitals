require 'spec_helper'

describe Vitals::Reporters::ConsoleReporter do
  let(:reporter) do
    reporter_one = Vitals::Reporters::ConsoleReporter.new(category: 'one', format: TestFormat.new)
    reporter_two = Vitals::Reporters::ConsoleReporter.new(category: 'two', format: TestFormat.new)

    Vitals::Reporters::MultiReporter.new(reporters: [
                                           reporter_one,
                                           reporter_two
                                         ])
  end

  it '#inc' do
    out, _ = capture_io { reporter.inc('1.2') }
    out.must_equal("one INC 1.2\ntwo INC 1.2\n")
  end

  it '#timing' do
    out, _ = capture_io { reporter.timing('1.2', 42) }
    out.must_equal("one TIME 1.2 42\ntwo TIME 1.2 42\n")
  end

  it '#gauge' do
    out, _ = capture_io { reporter.gauge('1.2', 32) }
    out.must_equal("one GAUGE 1.2 32\ntwo GAUGE 1.2 32\n")
  end

  it '#count' do
    out, _ = capture_io { reporter.count('1.2', 32) }
    out.must_equal("one COUNT 1.2 32\ntwo COUNT 1.2 32\n")
  end
end
