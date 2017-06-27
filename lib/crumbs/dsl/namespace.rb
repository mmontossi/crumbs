module Crumbs
  module Dsl
    class Namespace

      def initialize(prefix, &block)
        @prefix = prefix
        instance_eval(&block)
      end

      def controller(name, &block)
        Controller.new "#{@prefix}/#{name}", &block
      end

      def namespace(name, &block)
        Namespace.new "#{@prefix}/#{name}", &block
      end

    end
  end
end
