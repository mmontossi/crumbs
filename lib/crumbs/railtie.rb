module Crumbs
  class Railtie < Rails::Railtie

    initializer 'crumbs' do
      ::ActionController::Base.send :include, Crumbs::ActionController::Base
    end

    config.after_initialize do
      load Rails.root.join('config/crumbs.rb')
    end

  end
end
