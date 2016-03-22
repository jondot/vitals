
def assert_timings(reports, metrics, times, delta=30)
  if Object.const_defined?('RSpec')
    expect(reports.count).to eq metrics.count
    metrics.zip(times).each_with_index do |(m,v), i|
      expect(reports[i][:timing]).to eq m
      expect(reports[i][:val]).to be_within(delta).of(v)
    end
  else
    assert_equal reports.count, metrics.count
    metrics.zip(times).each_with_index do |(m,v), i|
      assert_equal reports[i][:timing], m
      assert_in_delta reports[i][:val], v, delta
    end
  end
end
