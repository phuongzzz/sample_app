Rails.application.routes.draw do
  root "static_pages#home"
  get "/about", to: "static_pages#about"
  get "/help", to: "static_pages#help"
  get "/contact", to: "static_pages#contact"
  get "/signup", to: "users#new"
  get "/signup", to: "users#create"
  resources :users,  only: [:new, :show, :create]
end
