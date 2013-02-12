require 'action_controller/metal/exceptions'

module RailsCrumbs
  module ActionController
    module Base
      module ClassMethods
        
        protected
        
        def crumb(action, name)
          controller = self.name.gsub('::', '/').gsub('Controller', '').underscore
          Crumbs.add(controller, action, name)
        end        
        
      end
      module InstanceMethods
      
        def self.included(base)
          base.send :before_filter, :define_crumbs
        end

        protected    
  
        def define_crumbs    
          check_referer
          parts = request.path.split('/')
          parts.pop unless Rails.application.config.crumbs.show_last
          @crumbs = []
          while parts.size > 0
            path = join_parts(parts)
            if params = find_path_params(path)
              if name = Crumbs.get_name(params[:controller], params[:action], params)
                if index = in_referer?(path)
                  path = session[:referer][index][:fullpath]
                end 
                @crumbs << {:name => name, :path => path}   
              end
            end       
            parts.pop      
          end  
          @crumbs.reverse!  
        end

        def find_path_params(path)
          begin
            Rails.application.routes.recognize_path(request.base_url + path) 
          rescue ::ActionController::RoutingError => e
            false
          end
        end

        def check_referer
          if session[:referer].nil?
            reset_referer
          elsif is_last_referer?
            last_index = session[:referer].size - 1
            session[:referer][last_index][:fullpath] = request.fullpath
          elsif add_to_referer?
            add_to_referer
          elsif index = in_referer_tree?
            session[:referer] = session[:referer].slice(Range.new(0, index))
            add_to_referer
          else
            reset_referer
          end  
        end

        def add_to_referer
          session[:referer] << {:base_url => request.base_url, :path => request.path, :fullpath => request.fullpath}
        end

        def reset_referer
          session[:referer] = [{:base_url => request.base_url, :path => request.path, :fullpath => request.fullpath}]   
        end
        
        def join_parts(parts)
          path = parts.join('/')
          (path[0] != '/' ? "/#{path}" : path)
        end
      
        def is_last_referer?
          last = session[:referer].last
          last[:base_url] == request.base_url and last[:path] == request.path
        end
  
        def add_to_referer?   
          last = session[:referer].last
          parts = request.path.split('/')
          parts.size > 0 and last[:path] == join_parts(parts.slice(0, parts.size - 1))
        end

        def in_referer?(path)
          find_in_referer path
        end

        def in_referer_tree?
          parts = request.path.split('/')
          parts.pop
          while parts.size > 0
            index = find_in_referer_tree(parts)            
            return index unless index.nil?
            parts.pop
          end
        end

        def find_in_referer(path)
          session[:referer].index do |referer|
            referer[:base_url] == request.base_url and referer[:path] == path
          end
        end         

        def find_in_referer_tree(parts)
          session[:referer].index do |referer|
            referer[:base_url] == request.base_url and 
            referer[:path] == join_parts(parts) and
            referer[:path] != request.path
          end
        end
       
      end  
    end
  end
end

ActionController::Base.send :include, RailsCrumbs::ActionController::Base::InstanceMethods
ActionController::Base.send :extend, RailsCrumbs::ActionController::Base::ClassMethods
