require 'spec_helper'
require 'bundler'


if ENV['INTEGRATION']
  describe "multiverse" do
    it "rails 4.2" do
      Bundler.with_clean_env do
        Dir.chdir('spec/multiverse/rails42_app') do
          system('pwd')
          system('ls')
          ignore_bundle = 'BUNDLE_IGNORE_CONFIG=1 '
          system("#{ignore_bundle}bundle config")
          system("#{ignore_bundle}install --path vendor/bundle && #{ignore_bundle}RAILS_ENV=test bundle exec rake db:migrate && #{ignore_bundle}bundle exec rake test").must_equal true
        end
      end
    end
    it "grape-rack" do
      Dir.chdir('spec/multiverse/grape-on-rack') do
        system('pwd')
        system('ls')
        system('bundle config')
        system('bundle install && bundle exec rake spec').must_equal true
      end
    end
    it "grape-rails" do
      Dir.chdir('spec/multiverse/grape-on-rails') do
        system('pwd')
        system('ls')
        system('bundle config')
        system('bundle install && RAILS_ENV=test bundle exec rake db:migrate && bundle exec rake spec').must_equal true
      end
    end
    it "padrino" do
      # TODO this should test the rack middleware, and padrino uses sinatra so that's good
      skip
    end
  end
end
