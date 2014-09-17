require 'crumbs/action_controller/base'
require 'crumbs/definitions'
require 'crumbs/railtie'

module Crumbs
  class << self

    def configure
      yield config
    end

    def config
      @config ||= begin
        ActiveSupport::OrderedOptions.new.tap do |config|
          config.show_last = false
        end
      end
    end

  end
end
