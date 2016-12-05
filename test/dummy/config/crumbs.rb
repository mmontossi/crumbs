Crumbs.define do

  namespace :admin do
    namespace :reports do
      controller :deliveries do
        crumb :index do
          'deliveries'
        end
      end
    end
    controller :users do
      crumb :index, 'users'
    end
  end

  crumb 'admin/users#show' do |params|
    "user #{params[:id]}"
  end

  controller :pages do
    crumb :index, t('.home')
  end

end
