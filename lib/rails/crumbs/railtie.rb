module Rails
  module Crumbs
    class Railtie < Rails::Railtie

      config.crumbs = ActiveSupport::OrderedOptions.new
      config.crumbs.show_last = false

      initializer 'crumbs.methods' do
        ::ActionController::Base.send :include, Rails::Crumbs::ActionController::InstanceMethods
        ::ActionController::Base.send :extend, Rails::Crumbs::ActionController::ClassMethods
      end

    end
  end
end
