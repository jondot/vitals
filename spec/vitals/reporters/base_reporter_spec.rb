require 'spec_helper'

describe Vitals::Reporters::BaseReporter do
  let(:reporter){ 
    Vitals::Reporters::BaseReporter.new
  }

  it '#time' do
    mock(reporter).timing.with_any_args{|m, v| 
      m.must_equal('1.2')
      v.must_be_within_delta(200, 20)
    }
    reporter.time('1.2'){
      sleep 0.2
    }
  end
end


