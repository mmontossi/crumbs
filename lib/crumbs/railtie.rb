module Crumbs
  class Railtie < Rails::Railtie

    config.crumbs = ActiveSupport::OrderedOptions.new
    config.crumbs.show_last = false

    initializer 'crumbs' do
      ::ActionController::Base.send :include, Crumbs::ActionController::Base
    end

  end
end
