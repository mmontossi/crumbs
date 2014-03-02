module Crumbs
  module ActionController
    module Base
      extend ActiveSupport::Concern

      included do
        before_filter :define_crumbs
      end

      protected 

      def define_crumbs
        update_referers
        parts = request.path.split('/')
        parts.pop unless Rails.application.config.crumbs.show_last
        @crumbs = []
        while parts.size > 0
          if crumb = find_crumb(parts.size == 1 ? '/' : parts.join('/'))
            @crumbs << crumb
          end
          parts.pop
        end
        @crumbs.reverse!
      end

      def find_crumb(path)
        params = Rails.application.routes.recognize_path(request.base_url + path) rescue return
        if name = Crumbs::Definitions.find(params[:controller], params[:action], params)
          if index = find_referer_index(path)
            path = referers[index][:fullpath]
          end
          { name: name, path: path }
        end
      end
 
      def referers
        session[:referers] ||= []
      end

      def referers=(value)
        session[:referers] = value
      end
 
      def find_referer_index(path)
        referers.index { |referer| referer[:base_url] == request.base_url and referer[:path] == path }
      end

      def update_referers
        if referers.empty? or index = find_referer_index(request.path) or (referers.last[:path].count('/') == 1 ? '/' : request.path[0...request.path.rindex('/')])
          if index == 0
            self.referers = []
          elsif index
            self.referers = referers[0...index]
          end
          referers << { base_url: request.base_url, path: request.path, fullpath: request.fullpath }
        else
          self.referers = [{ base_url: request.base_url, path: request.path, fullpath: request.fullpath }]
        end
      end
 
      module ClassMethods
 
        protected
 
        def crumb(action, name=nil, &block)
          controller = self.name.gsub('::', '/').gsub('Controller', '').underscore
          name = block_given? ? block : name
          Crumbs::Definitions.add controller.to_s, action.to_s, name
        end
 
      end
    end
  end
end
