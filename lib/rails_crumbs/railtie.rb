module RailsCrumbs
  class Railtie < Rails::Railtie

    config.crumbs = ActiveSupport::OrderedOptions.new
    config.crumbs.show_last = false

  end
end
