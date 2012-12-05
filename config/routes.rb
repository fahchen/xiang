Xiang::Application.routes.draw do

  match 'admin' => 'posts#index', as: 'admin'
  match 'admin/writting' => 'posts#new', as: 'admin_writting'
  match 'admin/comments' => 'comments#index', as: 'admin_comments'


  # session
  resources :sessions, only: [:new, :create, :destroy]
  match 'sign_in' => 'sessions#new', as: 'sign_in'
  match 'sign_out' => 'sessions#destroy', as: 'sign_out', via: :delete

  get ':slug' => 'posts#show'
  
  resources :posts do
    resources :comments
  end

  root to: 'posts#index'
end