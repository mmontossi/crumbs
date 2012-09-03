module RailsBreadcrumbs
  class Railtie < Rails::Railtie

    config.after_initialize do
      ::ActionController::Base.send :include, RailsBreadcrumbs::ActionController::BaseMethods
    end    

  end
end