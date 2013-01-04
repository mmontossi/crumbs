module RailsCrumbs
  class Crumbs
    class << self
    
      def all
        @all ||= {}
      end
    
      def add(controller, action, name)
        unless all.has_key? controller.to_sym
          all[controller.to_sym] = {action.to_sym => name}
        else 
          all[controller.to_sym][action.to_sym] = name
        end
      end
  
      def get_name(controller, action, params)
        return false unless all.has_key? controller.to_sym
        name = all[controller.to_sym][action.to_sym]
        case name
        when String
          name
        when Proc
          name.call(params)
        end
      end
  
    end
  end
end
