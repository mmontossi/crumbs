module Crumbs
  class Railtie < Rails::Railtie

    config.before_initialize do
      load Rails.root.join('config/crumbs.rb')
    end

    initializer 'crumbs.action_controller' do
      ActiveSupport.on_load :action_controller do
        ::ActionController::Base.include(
          Crumbs::Extensions::ActionController::Base
        )
      end
    end

  end
end
