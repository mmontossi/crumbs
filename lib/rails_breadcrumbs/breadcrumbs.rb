module RailsBreadcrumbs
  class Breadcrumbs
    class << self
    
      def all
        @all ||= {}
      end
    
      def add(controller, action, name)
        if all[controller.to_sym].nil?
          all[controller.to_sym] = {action.to_sym => name}
        else 
          all[controller.to_sym][action.to_sym] = name
        end
      end
  
      def get_name(controller, action, params)
        return false if all[controller.to_sym].nil?
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