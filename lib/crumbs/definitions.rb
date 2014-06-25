module Crumbs
  class Definitions
    class << self

      def all
        @all ||= {}
      end

      def add(controller, action, name)
        if all.has_key? controller
          all[controller][action] = name
        else
          all[controller] = { action => name }
        end
      end

      def find(controller, action, params)
        if all.has_key? controller and all[controller].has_key? action
          name = all[controller][action]
          name.is_a?(Proc) ? name.call(params) : name
        end
      end

    end
  end
end
