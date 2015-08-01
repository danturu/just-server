Rails.application.routes.draw do
  resources :events, only: [:create]

  root to: "pages#show", id: :home
end
