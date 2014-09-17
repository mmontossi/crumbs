require 'rails/generators'

module Crumbs
  class InstallGenerator < Rails::Generators::Base

    source_root File.expand_path('../templates', __FILE__)

    def create_initializer
      copy_file 'crumbs.rb', 'config/initializers/crumbs.rb'
    end

  end
end
