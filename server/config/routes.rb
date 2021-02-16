Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resource  :session, only: [:show, :create, :destroy]
  
  namespace :api do
    namespace :v1 do
      resources :users, only: [:show, :create, :update, :destroy]
    end
  end
end
