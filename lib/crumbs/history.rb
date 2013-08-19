module Crumbs
  class History
    class << self
    
      def all
        @all ||= {}
      end
    
      def add(controller, action, name)
        unless all.has_key? controller.to_sym
          all[controller.to_sym] = { action.to_sym => name }
        else 
          all[controller.to_sym][action.to_sym] = name
        end
      end
  
      def get_name(controller, action, params)
        return false unless all.has_key? controller.to_sym and all[controller.to_sym].has_key? action.to_sym
        name = all[controller.to_sym][action.to_sym]
        case name
        when String
          value = name
        when Proc
          value = name.call(params)
        end
        value ? value : ''
      end
  
    end
  end
end
