module Crumbs
  class Proxy

    def initialize(&block)
      instance_eval &block
    end

    %w(
      namespace
      controller
    ).each do |name|
      define_method name do |*args, &block|
        DSL.const_get(name.to_s.classify).new(*args, &block)
      end
    end

  end
end
