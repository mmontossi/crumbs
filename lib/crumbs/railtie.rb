module Crumbs
  class Railtie < Rails::Railtie

    initializer 'crumbs.extensions' do
      ::ActionController::Base.include(
        Crumbs::Extensions::ActionController::Base
      )
    end

    config.after_initialize do
      load Rails.root.join('config/crumbs.rb')
    end

  end
end
