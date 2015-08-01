module Crumbs
  module ActionController
    module Base
      extend ActiveSupport::Concern

      included do
        append_before_action :set_crumbs
      end

      protected

      def set_crumbs
        paths = [request.path]
        paths.unshift File.dirname(paths.first) until paths.first == '/'
        referer = { base_url: request.base_url, path: request.path, fullpath: request.fullpath }
        if session[:referers].nil? or session[:referers].last[:base_url] != request.base_url
          session[:referers] = [referer]
        elsif request.path.starts_with? "#{session[:referers].last[:path]}/".squeeze('/')
          session[:referers] << referer
        elsif index = find_referer_index(paths)
          session[:referers] = session[:referers][0...index] + [referer]
        elsif
          session[:referers] = [referer]
        end
        paths.pop unless Crumbs.config.show_last
        @crumbs = []
        paths.each do |path|
          params = Rails.application.routes.recognize_path("#{request.base_url}#{path}") rescue next
          if name = Crumbs.find(params[:controller], params[:action], params)
            if index = find_referer_index(path)
              path = session[:referers][index][:fullpath]
            end
            @crumbs << { name: name, path: path }
          end
        end
      end

      def find_referer_index(paths)
        paths = [paths] unless paths.is_a? Array
        session[:referers].rindex do |referer|
          paths.include? referer[:path]
        end
      end
    end

  end
end
