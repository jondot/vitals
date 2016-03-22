require 'spec_helper'
require 'bundler'
require 'fileutils'
include FileUtils


describe "multiverse" do
  let(:bundle){ 'bundle install --quiet --path=vendor/bundle' }
  def state
    puts `pwd`
  end
  it "rails 4.2" do
    Bundler.with_clean_env do
      Dir.chdir('integration/multiverse/rails42_app') do
        state
        system("#{bundle} && RAILS_ENV=test bundle exec rake db:migrate && bundle exec rake test").must_equal true
      end
    end
  end
  it "grape-rack" do
    Bundler.with_clean_env do
      Dir.chdir('integration/multiverse/grape-on-rack') do
        state
        system("#{bundle} && bundle exec rake spec").must_equal true
      end
    end
  end
  it "grape-rails" do
    Bundler.with_clean_env do
      Dir.chdir('integration/multiverse/grape-on-rails') do
        state
        system("#{ bundle } && bundle exec rake spec").must_equal true
      end
    end
  end
  it "padrino" do
    # TODO this should test the rack middleware, and padrino uses sinatra so that's good
    skip
  end
end
