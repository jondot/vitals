require 'spec_helper'

describe Vitals::Reporters::RiemannReporter do

  let(:reporter){ Vitals::Reporters::RiemannReporter.new(host: 'localhost', port: 5555, format: TestFormat.new) }
  let(:epoch_now){ 12345 }

  it 'should set up riemann' do
    skip("implement")
  end

  it '#inc' do
    freeze_time_at(epoch_now) do
      event = {:service=>"1.2", :metric=>1, :time=>epoch_now, :tags=>["vitals", "counter"]}
      mock(reporter.riemann).<<(event).times(1)
      reporter.inc('1.2')
    end
  end

  it '#timing' do
    freeze_time_at(epoch_now) do
      event = {:service=>"1.2", :metric=>42, :time=>epoch_now, :tags=>["vitals", "timer"]}
      mock(reporter.riemann).<<(event).times(1)
      reporter.timing('1.2', 42)
    end
  end

  it '#gauge' do
    freeze_time_at(epoch_now) do
      event = {:service=>"1.2", :metric=>32, :time=>epoch_now, :tags=>["vitals", "gauge"]}
      mock(reporter.riemann).<<(event).times(1)
      reporter.gauge('1.2', 32)
    end
  end
end

