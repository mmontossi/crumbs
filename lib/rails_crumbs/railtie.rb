module RailsCrumbs
  class Railtie < Rails::Railtie

    config.crumbs = ActiveSupport::OrderedOptions.new
    config.crumbs.show_last = false

    initializer 'crumbs.methods' do
      ::ActionController::Base.send :include, RailsCrumbs::ActionController::Base::InstanceMethods
      ::ActionController::Base.send :extend, RailsCrumbs::ActionController::Base::ClassMethods
    end

  end
end
