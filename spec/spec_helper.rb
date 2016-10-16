$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'coveralls'
Coveralls.wear!

require 'vitals'

require 'minitest/spec'
require 'minitest/autorun'
require 'rr'

require 'rack/test'

require 'benchmark/ipsa'
require 'memory_profiler'

# TODO: remember to set vitals config to nil
# globally for the test suite so that we don't
# have test fallout (Vitals is static)

# TODO: extract this pattern to a gem
def bench(label, cases)
  it "bench #{label}" do
    Benchmark.ipsa do |x|
      cases.each do |name, block|
        x.report(name, block)
      end
    end
  end
end

def format_configs
  [
    {
      environment: 'env/foo-bar baz:qux',
      facility:    'service/foo-bar baz:qux',
      host:        'host/foo-bar baz:qux'
    },
    {
      environment: 'env',
      facility:    'service',
      host:        'host'
    },
    {
      environment: 'env',
      facility:    nil,
      host:        'host'
    },
    {
      environment: 'env',
      facility:    'service',
      host:        nil
    },
    {
      environment: nil,
      facility:    'service',
      host:        'host'
    },
    {
      environment: 'env',
      facility:    nil,
      host:        nil
    },
    {
      environment: nil,
      facility:    nil,
      host:        'host'
    },
    {
      environment: nil,
      facility:    'service',
      host:        nil
    }
  ]
end

def format_cases
  ['1.2',
   '1',
   '',
   nil]
end

def it_formats(format_class, results)
  describe format_class do
    format_configs.each_with_index do |format_config, fi|
      format_cases.each_with_index do |args, index|
        result_index = fi * format_cases.size + index
        if result_index < results.size
          res = results[result_index]
          it "formats with #{fi}: #{format_config}(#{args}) -> [#{res}] (index: #{result_index})" do
            format_class.new(format_config).format(args).must_equal(res)
          end
        end
      end
    end
  end
end

class TestFormat
  def format(args)
    args
  end
end

require 'grape'
