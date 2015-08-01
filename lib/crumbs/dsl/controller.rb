module Crumbs
  module DSL
    class Controller

      def initialize(controller, &block)
        @controller = controller
        instance_eval &block
      end

      def action(action, name=nil, &block)
        Crumbs.add(
          @controller.to_s,
          action.to_s,
          (block_given? ? block : name)
        )
      end

      def t(key)
        if key.starts_with? '.'
          key.prepend 'crumbs'
        end
        I18n.t(key)
      end

    end
  end
end
