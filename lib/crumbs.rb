require 'crumbs/dsl/namespace'
require 'crumbs/dsl/controller'
require 'crumbs/extensions/action_controller/base'
require 'crumbs/definitions'
require 'crumbs/proxy'
require 'crumbs/railtie'
require 'crumbs/version'

module Crumbs
  class << self

    def define(&block)
      Proxy.new(&block)
    end

    def definitions
      @definitions ||= Definitions.new
    end

  end
end
