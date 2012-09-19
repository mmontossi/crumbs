module RailsBreadcrumbs
  module ActionController
    module Base
      module ClassMethods
        
        protected
        
        def breadcrumb(action, name)
          controller = self.name.gsub('::', '/').gsub('Controller', '').underscore
          Breadcrumbs.add(controller, action, name)
        end        
        
        def t(key, options = {})
          proc { I18n.t key, options } # I18n.locale it's set after breadcrumb method it's called, so basically it's a hack to call later
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
          elsif index = in_referer_tree?
            session[:referer] = session[:referer].slice(Range.new(0, index))    
            session[:referer] << {:base_url => request.base_url, :path => request.path, :fullpath => request.fullpath}
          else
            session[:referer] = [{:base_url => request.base_url, :path => request.path, :fullpath => request.fullpath}]            
          end       
        
          parts = request.path.split('/')
          parts.pop 
          path = join_parts(parts)           
        
          @breadcrumbs = []    
          while parts.size > 0    
            if params = Rails.application.routes.recognize_path(request.base_url + path)
              debugger
              if name = Breadcrumbs.get_name(params[:controller], params[:action], params)
                if index = in_referer?(path)
                  path = session[:referer][index][:fullpath]
                end        
                @breadcrumbs << {:name => name, :path => path}   
              end
            end       
            parts.pop      
            path = join_parts(parts)
          end  
          @breadcrumbs.reverse!    
    
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

        def in_referer_tree?
          parts = request.path.split('/')
          parts.pop
          while parts.size > 0
            index = session[:referer].index do |referer|
              referer[:base_url] == request.base_url and 
              referer[:path] == join_parts(parts) and
              referer[:path] != request.path
            end
            return index unless index.nil?
            parts.pop
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