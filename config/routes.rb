# config/routes.rb
Rails.application.routes.draw do
  # La página de inicio ahora mostrará el formulario para un nuevo juego.
  root "games#create"

  # Añadimos :index y :create a las rutas de resources.
  # :index -> GET /games (Página de historial)
  # :create -> POST /games (Recibe los datos del formulario de nuevo juego)
  resources :games, only: [:new, :create, :show, :index] do
    member do
      post 'move'
    end

    collection do 
      get 'new_vs_ai', to: 'games#new_vs_ai'
      post 'create_vs_ai'
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end