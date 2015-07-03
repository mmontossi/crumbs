Crumbs.define do

  controller :pages do
    action :home, 'Home'
    action :static do
      'Static'
    end
    action :i18n do
      I18n.t('hello')
    end
    action :nested do |params|
      'Nested'
    end
    action :param do |params|
      "Param#{params[:param]}"
    end
  end

end
