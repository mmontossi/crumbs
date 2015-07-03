require 'crumbs/action_controller/base'
require 'crumbs/proxy'
require 'crumbs/controller'
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
      Proxy.new.instance_eval &block
    end

    def find(controller, action, params)
      if all.has_key? controller and all[controller].has_key? action
        name = all[controller][action]
        if name.is_a? Proc
          name.call params
        else
          name
        end
      end
    end

    def all
      @all ||= {}
    end

  end
end
