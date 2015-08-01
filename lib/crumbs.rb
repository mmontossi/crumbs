require 'crumbs/action_controller/base'
require 'crumbs/proxy'
require 'crumbs/dsl/namespace'
require 'crumbs/dsl/controller'
require 'crumbs/railtie'

module Crumbs
  class << self

    def configure
      yield config
    end

    def config
      @config ||= begin
        ActiveSupport::OrderedOptions.new.tap do |config|
          config.show_last = false
        end
      end
    end

    def define(&block)
      Proxy.new(&block)
    end

    def find(controller, action, params)
      if registry.has_key? controller and registry[controller].has_key? action
        name = registry[controller][action]
        if name.is_a? Proc
          name.call params
        else
          name
        end
      end
    end

    def add(controller, action, name)
      if registry.has_key? controller
        registry[controller][action] = name
      else
        registry[controller] = { action => name }
      end
    end

    protected

    def registry
      @registry ||= {}
    end

  end
end
