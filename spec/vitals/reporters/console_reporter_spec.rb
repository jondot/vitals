require 'spec_helper'

describe Vitals::Reporters::ConsoleReporter do
  let(:reporter) { Vitals::Reporters::ConsoleReporter.new(category: 'main', format: TestFormat.new) }

  it '#inc' do
    out, _ = capture_io { reporter.inc('1.2') }
    out.must_equal("main INC 1.2\n")
  end

  it '#timing' do
    out, _ = capture_io { reporter.timing('1.2', 42) }
    out.must_equal("main TIME 1.2 42\n")
  end

  it '#gauge' do
    out, _ = capture_io { reporter.gauge('1.2', 32) }
    out.must_equal("main GAUGE 1.2 32\n")
  end

  it '#count' do
    out, _ = capture_io { reporter.count('1.2', 32) }
    out.must_equal("main COUNT 1.2 32\n")
  end
end
