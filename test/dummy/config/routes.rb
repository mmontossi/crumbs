Rails.application.routes.draw do

  namespace :admin do
    namespace :reports do
      get 'deliveries' => 'deliveries#index'
    end
    get 'users' => 'users#index'
    get 'users/:id' => 'users#show'
  end

  root to: 'pages#index'

end
