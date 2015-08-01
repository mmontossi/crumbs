module Crumbs
  module DSL
    class Namespace

      def initialize(namespace, &block)
        @namespace = namespace
        instance_eval &block
      end

      def controller(name, &block)
        Controller.new("#{@namsepace}/#{name}", &block)
      end

    end
  end
end
