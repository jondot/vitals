class VitalsGenerator < Rails::Generators::Base


  class_option :statsd_host,  :desc => "statsd host ip or name"
  class_option :port, :desc => "statsd host port"

  source_root File.expand_path('../templates', __FILE__)

  def create_initializer
    template "vitals_initializer.rb", "config/initializers/vitals_initializer.rb"
  end
end
