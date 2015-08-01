Crumbs.define do

  namespace :namespace do
    controller :pages do
      action :index, 'Namespaced Home'
    end
  end

  controller :pages do
    action :index, 'Home'
    action :nested, 'Nested'
    action :i18n, t('.hello')
    action :static do
      t('.static')
    end
    action :param do |params|
      "Param#{params[:param]}"
    end
  end

end
