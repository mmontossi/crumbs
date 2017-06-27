module Crumbs
  class Proxy

    def initialize(&block)
      instance_eval(&block)
    end

    def namespace(*args, &block)
      Dsl::Namespace.new(*args, &block)
    end

    def controller(*args, &block)
      Dsl::Controller.new(*args, &block)
    end

    def crumb(action, name=nil, &block)
      Crumbs.definitions.add action, (block_given? ? block : name)
    end

  end
end
