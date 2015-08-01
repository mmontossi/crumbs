class PagesController < ApplicationController

  def index
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
