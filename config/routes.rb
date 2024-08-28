Rails.application.routes.draw do
  root "main#index"
  get "/admin/dashboard" => "admin/dashboard#index"
  get "/admin" => "admin/login#new"
  post "/admin" => "admin/login#login"
  delete "/admin/logout" => "admin/login#logout"

  namespace :admin do
    resources :users
    resources :articles
    resources :categories
    resources :app_banners
    resources :ft_app_users
  end
  namespace :shopit do
    get "/admin" => "admin/login#new"
    post "/admin" => "admin/login#login"
    delete "/admin/logout" => "admin/login#logout"
    get "/admin/dashboard" => "admin/dashboard#index"
    namespace :admin do
      resources :shopit_users
      resources :products
      resources :shopit_categories
      resources :checkouts
      get "/shopit_category/:id/products" => "shopit_categories#products"
    end
  end
  namespace :astrologies do
    get "/admin" => "admin/login#new"
    post "/admin" => "admin/login#login"
    delete "/admin/logout" => "admin/login#logout"
    get "/admin/dashboard" => "admin/dashboard#index"
    namespace :admin do
      resources :astrologies_users
      resources :astrologies_app_banners
      resources :astrologies
    end
  end
  get "/acdelete" => "acdelete#new"
  post "/acdelete" => "acdelete#create"

  mount API::Base => "/"
  mount API::V1::Shopit::Base => "/shopit"
end
