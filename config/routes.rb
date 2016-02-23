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

  resources :users, only: :show
  resources :vehicles
  resources :photos

  resources :vehicles do
    resources :reservations, only: [:create]
  end

  get '/preload' => 'reservations#preload'
end
