module Crumbs
  module Dsl
    class Controller

      def initialize(prefix, &block)
        @prefix = prefix
        instance_eval &block
      end

      def crumb(action, name=nil, &block)
        Crumbs.definitions.add "#{@prefix}##{action}", (block_given? ? block : name)
      end

      def t(key)
        if key.starts_with?('.')
          key.prepend 'crumbs'
        end
        I18n.t key
      end

    end
  end
end
