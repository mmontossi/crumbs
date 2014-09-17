require 'test_helper'
require 'rails/generators'
require 'generators/crumbs/install_generator'

class GeneratorsTest < Rails::Generators::TestCase
  tests Crumbs::InstallGenerator
  destination File.expand_path('../tmp', File.dirname(__FILE__))

  teardown do
    FileUtils.rm_rf self.destination_root
  end

  test 'generate initializer' do
    run_generator
    assert_file 'config/initializers/crumbs.rb'
  end

end
