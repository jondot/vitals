require 'spec_helper'

describe Vitals::Reporters::InmemReporter do
  let(:reporter) { Vitals::Reporters::InmemReporter.new }

  it '#inc' do
    reporter.inc '1.2'
    reporter.reports.must_equal([{ :inc => '1.2' }])
  end

  it '#gauge' do
    reporter.gauge '1.2', 42
    reporter.reports.must_equal([{ :gauge => '1.2', :val => 42 }])
  end

  it '#count' do
    reporter.count '1.2', 42
    reporter.reports.must_equal([{ :count => '1.2', :val => 42 }])
  end

  it '#timing' do
    reporter.timing '1.2', 42
    reporter.reports.must_equal([{ :timing => '1.2', :val => 42 }])
  end
end
