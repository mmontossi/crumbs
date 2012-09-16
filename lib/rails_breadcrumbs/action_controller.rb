module RailsBreadcrumbs
  module ActionController
    module Base
      module ClassMethods
        
        protected
        
        def breadcrumb(action, name)
          controller = self.name.gsub('::', '').gsub('Controller', '').underscore
          Breadcrumbs.add(controller, action, name)
        end        
        
        def t(key, options = {})
          I18n.t key, options
        end
        
      end
      module InstanceMethods
      
        def self.included(base)
          base.send :before_filter, :breadcrumbs
        end

        protected    
  
        def breadcrumbs
     
          if session[:referer].nil?
            session[:referer] = [{:base_url => request.base_url, :path => request.path, :fullpath => request.fullpath}]
          elsif is_last_referer?
            last_index = session[:referer].size - 1
            session[:referer][last_index][:fullpath] = request.fullpath
          elsif add_to_referer?
            session[:referer] << {:base_url => request.base_url, :path => request.path, :fullpath => request.fullpath}
          elsif index = in_tree_referer?
            session[:referer] = session[:referer].slice(Range.new(0, index))    
            session[:referer] << {:base_url => request.base_url, :path => request.path, :fullpath => request.fullpath}
          else
            session[:referer] = [{:base_url => request.base_url, :path => request.path, :fullpath => request.fullpath}]            
          end        
            
          path_parts = request.path.split('/')
          path_parts.pop      
          path = path_parts.join('/')
        
          @breadcrumbs = []    
          while path_parts.size > 0    
            if params = Rails.application.routes.recognize_path(path) 
              name = Breadcrumbs.get_name(params[:controller], params[:action], params)
              if index = in_referer?(path)
                path = session[:referer][index][:fullpath]
              end        
              @breadcrumbs << {:name => name, :path => path}   
            end       
            path_parts.pop      
            path = path_parts.join('/')
          end  
          @breadcrumbs.reverse!    
    
        end
      
        def is_last_referer?
          last = session[:referer].last
          last[:base_url] == request.base_url and last[:path] == request.path
        end
  
        def add_to_referer?   
          last = session[:referer].last
          path_parts = request.path.split('/')
          path_parts.size > 0 and last[:path] == path_parts.slice(0, path_parts.size - 1).join('/')
        end

        def in_tree_referer?
          path_parts = request.path.split('/')
          path_parts.pop
          while path_parts.size > 0
            index = session[:referer].index do |referer|
              referer[:base_url] == request.base_url and 
              referer[:path] == path_parts.join('/') and
              referer[:path] != request.path
            end
            return index unless index.nil?
            path_parts.pop
          end        
        end

        def in_referer?(path)
          index = session[:referer].index do |referer|
            referer[:base_url] == request.base_url and referer[:path] == path
          end
        end 
       
      end  
    end
  end
end

ActionController::Base.send :include, RailsBreadcrumbs::ActionController::Base::InstanceMethods
ActionController::Base.send :extend, RailsBreadcrumbs::ActionController::Base::ClassMethods