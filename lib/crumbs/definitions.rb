module Crumbs
  class Definitions

    def find(id, params)
      if registry.has_key?(id)
        name = registry[id]
        if name.is_a?(Proc)
          name.call params
        else
          name
        end
      end
    end

    def add(id, name)
      registry[id] = name
    end

    private

    def registry
      @registry ||= {}
    end

  end
end
