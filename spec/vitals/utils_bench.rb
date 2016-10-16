require 'spec_helper'

describe Vitals::Utils do
  bench '#normalize_metric',
        'bad metric'  => -> {
          Vitals::Utils.normalize_metric('service/foo-bar baz:qux')
        },
        'good metric' => -> {
          Vitals::Utils.normalize_metric('good_looking.metric__baz')
        }
end
