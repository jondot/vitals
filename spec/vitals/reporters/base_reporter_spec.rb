require 'spec_helper'

describe Vitals::Reporters::BaseReporter do
  let(:reporter) do
    Vitals::Reporters::BaseReporter.new
  end

  it '#time' do
    mock(reporter).timing.with_any_args do |m, v|
      m.must_equal('1.2')
      v.must_be_within_delta(200, 20)
    end
    reporter.time('1.2') do
      sleep 0.2
    end
  end
end
