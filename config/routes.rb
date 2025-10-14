# config/routes.rb
Rails.application.routes.draw do
  # La página de inicio ahora mostrará el formulario para un nuevo juego.
  root "games#new"

  # Añadimos :index y :create a las rutas de resources.
  # :index -> GET /games (Página de historial)
  # :create -> POST /games (Recibe los datos del formulario de nuevo juego)
  resources :games, only: [:new, :create, :show, :index] do
    member do
      post 'move'
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end