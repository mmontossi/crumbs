module Crumbs
  class Controller

    def initialize(controller)
      @controller = controller
    end

    def action(action, name=nil, &block)
      controller = @controller.to_s
      action = action.to_s
      name = (block_given? ? block : name)
      all = Crumbs.all
      if all.has_key? controller
        all[controller][action] = name
      else
        all[controller] = { action => name }
      end
    end

  end
end
