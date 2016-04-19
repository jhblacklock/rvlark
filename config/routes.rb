Rails.application.routes.draw do
  root 'pages#home'

  devise_for :users,
             path: '',
             path_names: { sign_in: 'login', sign_out: 'logout', edit: 'profile' },
             controllers: {
               omniauth_callbacks: 'omniauth_callbacks',
               registrations: 'registrations',
               sessions: 'sessions'
             }

  resources :users, only: :show do
    resources :reservations, only: [:index] do
      collection do
        get :trips
      end
    end
  end

  resources :photos
  resources :vehicles do
    resources :bookings, only: [:create]
    resources :reservations, only: [:create] do
      collection do
        get :available
        post :book
        post :price
      end
    end
  end

  resources :bookings do
    member do
      get :accept
      get :decline
    end
  end

  get '/s' => 'vehicles#search_gate', as: :search_vehicles_gate

  get '/s/(:state)/(:city)' => 'vehicles#search', as: :search_vehicles

  get '/preload' => 'reservations#preload'
end
