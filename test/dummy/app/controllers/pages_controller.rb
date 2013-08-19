class PagesController < ApplicationController

  crumb :home, 'Home'
  crumb :static, 'Static'
  crumb :i18n, I18n.t('hello')
  crumb :nested, proc { |params| 'Nested' }
  crumb :param, proc { |params| params[:param] }

  def home
    render :crumbs
  end

  def static
    render :crumbs
  end
  
  def i18n
    render :crumbs
  end

  def nested
    render :crumbs
  end

  def param
    render :crumbs
  end

  def empty
    render :crumbs
  end

end
