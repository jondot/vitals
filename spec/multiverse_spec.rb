require 'spec_helper'


if ENV['INTEGRATION']
  describe "multiverse" do
    it "rails 4.2" do
      system('cd spec/multiverse/rails42_app && bundle install --quiet && RAILS_ENV=test bundle exec rake db:migrate && bundle exec rake test').must_equal true
    end
    it "grape-rack" do
      system('cd spec/multiverse/grape-on-rack && bundle install --quiet && bundle exec rake spec').must_equal true
    end
    it "grape-rails" do
      system('cd spec/multiverse/grape-on-rails && bundle install --quiet && RAILS_ENV=test bundle exec rake db:migrate && bundle exec rake spec').must_equal true
    end
    it "padrino" do
      # TODO this should test the rack middleware, and padrino uses sinatra so that's good
      skip
    end
  end
end
