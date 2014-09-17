module Crumbs
  class Railtie < Rails::Railtie

    initializer 'crumbs' do
      ::ActionController::Base.send :include, Crumbs::ActionController::Base
    end

  end
end
