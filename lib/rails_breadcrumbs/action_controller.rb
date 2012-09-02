module RailsBreadcrumbs
  module ActionController
    module BaseMethods
      
      def self.included(base)
        base.send :before_filter, :breadcrumbs
      end

      protected    
  
      def breadcrumbs
     
        if session[:referrer].nil?
          session[:referrer] = [{:path => request.path, :fullpath => request.fullpath}]
        elsif request.path != session[:referrer].last[:path]
          if add_to_referrer?
            session[:referrer] << {:path => request.path, :fullpath => request.fullpath}
          elsif index = in_referrer?
            session[:referrer] = session[:referrer].slice(Range.new(0, (index - 1)))    
            session[:referrer] << {:path => request.path, :fullpath => request.fullpath}
          else
            session[:referrer] = [{:path => request.path, :fullpath => request.fullpath}]            
          end
        end   
    
        path_parameters = request.path_parameters.dup
        controller = path_parameters.delete :controller
        action = path_parameters.delete :action
        path = request.path.dup
        pattern = path.dup
        path_parameters.each_pair do |key, value|
          pattern.gsub! value, ":#{key}" 
        end
    
        @breadcrumbs = []         
        path_parts = path.split('/').select{|p|p!=''}
        pattern_parts = pattern.split('/').select{|p|p!=''}
        i = 0
        while path_parts.size > 0    
          if controller == 'dynamic'
            route = pattern_parts[0] == ':locale' ? path_parts.slice(1, path_parts.size - 1).join('/') : path_parts.join('/')  
            route = Route.where(:route => route, :locale => I18n.locale).first
            @breadcrumbs << {:name => route.routable.name, :path => dynamic_url(:route => route.route, :locale => I18n.locale)} if route
          else          
            title = []
            if path_parts.size < 2
              title << 'home'              
            else
              path_parts_en = url_for(:locale => :en, :only_path => true).split('/').select{|p|p!=''}
              path_parts.each_index do |i| 
                title << path_parts_en[i] unless i == 0 or pattern_parts[i][0] == ':' or pattern_parts[i][0] == '*'
              end
            end
            @breadcrumbs << {
              :name => t("pages.#{title.join('/').gsub('-', '_')}.title", :locale => I18n.locale), 
              :path => url_for(path, :locale => I18n.locale)
            }
          end
          index = in_referrer?(path)
          if @breadcrumbs.any? and index
            @breadcrumbs.last[:path] = session[:referrer][index][:fullpath]
          end 
          path_parts.pop      
          i += 1
        end  
        @breadcrumbs.reverse!    
    
      end
  
      def add_to_referrer?   
        last = session[:referrer].last[:path]
        path_parts = request.path.split('/')
        in_tree = last == path_parts.slice(0, path_parts.size - 1).join('/')
        in_tree and request.path != last
      end

      def in_referrer?(path=request.path)
        session[:referrer].index do |referrer|
          referrer[:path] == path
        end
      end 
         
    end
  end
end
      
ActionController::Base.send :include, RailsBreadcrumbs::ActionController::BaseMethods