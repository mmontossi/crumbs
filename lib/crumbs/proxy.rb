module Crumbs
  class Proxy

    def controller(name, &block)
      Controller.new(name).instance_eval(&block)
    end

  end
end
