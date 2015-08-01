require 'test_helper'
require 'rails/generators'
require 'generators/crumbs/install_generator'

class GeneratorsTest < Rails::Generators::TestCase
  tests Crumbs::InstallGenerator
  destination Rails.root.join('tmp')

  teardown do
    FileUtils.rm_rf self.destination_root
  end

  test 'initializer generator' do
    run_generator
    assert_file 'config/initializers/crumbs.rb'
    assert_file 'config/crumbs.rb'
  end

end
