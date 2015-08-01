class Namespace::PagesController < ApplicationController

  def index
    render template: 'pages/crumbs'
  end

end

