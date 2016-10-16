require 'spec_helper'

describe Vitals::Utils do
  it '#normalize_metric' do
    Vitals::Utils.normalize_metric('service/foo-bar baz:qux')
                 .must_equal('service_foo_bar_baz_qux')
    Vitals::Utils.normalize_metric('legal_looking.metric_like__that')
                 .must_equal('legal_looking.metric_like__that')
  end
end
