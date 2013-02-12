class TestController < ApplicationController

  crumb :home, 'Home'
  crumb :static, 'Static'
  crumb :i18n, I18n.t('hello')
  crumb :nested, proc { |params| 'Nested' }
  crumb :param, proc { |params| params[:param] }

  def home
  end

  def static
  end
  
  def i18n
  end

  def nested
  end

  def param
  end

  def empty
  end

end
