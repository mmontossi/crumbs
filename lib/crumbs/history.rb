module Crumbs
  class History
    class << self
    
      def all
        @all ||= {}
      end
    
      def add(controller, action, name)
        controller = controller.to_sym
        action = action.to_sym
        unless all.has_key? controller
          all[controller] = { action => name }
        else 
          all[controller][action] = name
        end
      end
  
      def get_name(controller, action, params)
        controller = controller.to_sym
        action = action.to_sym
        return false unless all.has_key? controller and all[controller].has_key? action
        name = all[controller][action]
        if name.respond_to? :call
          value = name.call(params)
        elsif
          value = name
        end
        value ? value : ''
      end
  
    end
  end
end
