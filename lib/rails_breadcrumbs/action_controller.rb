module RailsBreadcrumbs
  module ActionController
    module BaseMethods
      
      def self.included(base)
        base.send :before_filter, :breadcrumbs
      end

      protected    
  
      def breadcrumbs
     
        if session[:referer].nil?
          session[:referer] = [{:base_url => request.base_url, :path => request.path, :url => request.url}]
        elsif is_last_referer?
          if add_to_referer?
            session[:referer] << {:base_url => request.base_url, :path => request.path, :url => request.url}
          elsif index = in_referer?
            session[:referer] = session[:referer].slice(Range.new(0, (index - 1)))    
            session[:referer] << {:base_url => request.base_url, :path => request.path, :url => request.url}
          else
            session[:referer] = [{:base_url => request.base_url, :path => request.path, :url => request.url}]            
          end
        else
          last_index = session[:referer].size - 1
          session[:referer][last_index] = {:base_url => request.base_url, :path => request.path, :url => request.url}
        end   
        
        path_parts_en = url_for(:locale => :en).split('/').select{|p|p!=''}
    
        path_parts = request.path.split('/').select{|p|p!=''}
        path_parts.pop
        path = "/#{path_parts.join('/')}"
        
        pattern = path.dup
        request.path_parameters.each_pair do |key, value|
          pattern.gsub! value, ":#{key}" unless [:action, :controller].include? key
        end        
        pattern_parts = pattern.split('/').select{|p|p!=''}
        
        @breadcrumbs = []    
        i = 0
        while path_parts.size > 0    
          info = Rails.application.routes.recognize_path path 
          controller = info[:controller]
          action = info[:action]
          
          if controller == 'dynamic'
            route = pattern_parts.first == ':locale' ? path_parts.slice(1, path_parts.size - 1).join('/') : path_parts.join('/')  
            route = Route.where(:route => route, :locale => I18n.locale).first
            @breadcrumbs << {:name => route.routable.name, :url => "#{request.base_url}#{path}"} if route
          else          
            title = []
            if path_parts.size < 2
              title << 'home'              
            else
              path_parts.each_index do |i| 
                title << path_parts_en[i] unless i == 0 or pattern_parts[i][0] == ':' or pattern_parts[i][0] == '*'
              end
            end
            @breadcrumbs << {
              :name => t("pages.#{title.join('/').gsub('-', '_')}.title", :locale => I18n.locale), 
              :url => "#{request.base_url}#{path}"
            }
          end
          
          index = in_referer?(request.base_url, path)
          if @breadcrumbs.any? and not index.nil?
            @breadcrumbs.last[:url] = session[:referer][index][:url] 
          end        
          
          path_parts.pop      
          path = "/#{path_parts.join('/')}"
          pattern_parts.pop
          pattern = "/#{pattern_parts.join('/')}"
          i += 1
        end  
        @breadcrumbs.reverse!    
    
      end
      
      def is_last_referer?
        last = session[:referer].last
        last[:base_url] == request.base_url && last[:path] == request.path
      end
  
      def add_to_referer?   
        last = session[:referer].last
        return false unless last[:base_url] == request.base_url
        path_parts = request.path.split('/')
        in_tree = last[:path] == path_parts.slice(0, path_parts.size - 1).join('/')
        in_tree and request.path != last[:path]
      end

      def in_referer?(base_url=request.base_url, path=request.path)
        session[:referer].index do |referer|
          referer[:base_url] == base_url and referer[:path] == path
        end
      end 
         
    end
  end
end

ActionController::Base.send :include, RailsBreadcrumbs::ActionController::BaseMethods