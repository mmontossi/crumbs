module Crumbs
  module Extensions
    module ActionController
      module Base
        extend ActiveSupport::Concern

        included do
          before_action :set_crumbs
        end

        private

        def set_crumbs
          paths = [request.path]
          until paths.first == '/'
            paths.prepend File.dirname(paths.first)
          end
          session[:referers] ||= {}
          url, query = request.url.split(/\/?\?/)
          if query
            session[:referers][url] = query
          end
          @crumbs = []
          paths.each do |path|
            url = "#{request.base_url}#{path}".remove(/\/$/)
            begin
              params = Rails.application.routes.recognize_path(url)
            rescue
              next
            end
            if name = Crumbs.definitions.find("#{params[:controller]}##{params[:action]}", params)
              if query = session[:referers][url]
                url << "?#{query}"
              end
              @crumbs << { name: name, url: url }
            end
          end
        end

      end
    end
  end
end
