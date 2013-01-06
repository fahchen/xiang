Xiang::Application.routes.draw do

  match 'admin' => 'posts#index', as: 'admin'
  match 'admin/writing' => 'posts#new', as: 'admin_writing'
  resources :photos, only: [:create]

  # session
  resources :sessions, only: [:new, :create, :destroy]
  match 'sign_in' => 'sessions#new', as: 'sign_in'
  match 'sign_out' => 'sessions#destroy', as: 'sign_out', via: :delete

  get ':slug' => 'posts#show', as: 'show'
  get 'page/:page' => 'posts#index'

  post "/posts/preview" => "posts#preview"
  resources :posts

  root to: 'posts#index'
end