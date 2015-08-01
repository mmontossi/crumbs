require 'rails/generators'

module Crumbs
  class InstallGenerator < Rails::Generators::Base

    source_root File.expand_path('../templates', __FILE__)

    def create_initializer
      copy_file 'configure.rb', 'config/initializers/crumbs.rb'
      copy_file 'define.rb', 'config/crumbs.rb'
    end

  end
end
