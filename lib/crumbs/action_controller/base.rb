module Crumbs
  module ActionController
    module Base
      extend ActiveSupport::Concern

      included do
        before_filter :define_crumbs
      end

      protected 

      def define_crumbs
        paths = [request.path]
        paths.unshift File.dirname(paths.first) until paths.first == '/'
        if referers.empty? or referers.last[:base_url] != request.base_url
          self.referers = [build_referer]
        elsif request.path.starts_with? "#{referers.last[:path]}/".squeeze('/')
          self.referers << build_referer
        elsif index = find_referer_index(paths)
          self.referers = referers[0...index] + [build_referer]
        elsif
          self.referers = [build_referer]
        end
        paths.pop unless Rails.application.config.crumbs.show_last
        @crumbs = []
        paths.each do |path|
          params = Rails.application.routes.recognize_path("#{request.base_url}#{path}") rescue next
          if name = Crumbs::Definitions.find(params[:controller], params[:action], params)
            if index = find_referer_index(path)
              path = referers[index][:fullpath]
            end
            @crumbs << { name: name, path: path }
          end
        end
      end

      def referers
        session[:referers] ||= []
      end

      def referers=(value)
        session[:referers] = value
      end

      def build_referer
        { base_url: request.base_url, path: request.path, fullpath: request.fullpath }
      end
 
      def find_referer_index(paths)
        paths = [paths] unless paths.is_a? Array
        referers.rindex { |referer| paths.include? referer[:path] }
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
