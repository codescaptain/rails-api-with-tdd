Rails.application.routes.draw do
  post 'auth/tokens', to: 'access_tokens#create'
  delete 'auth/tokens', to: 'access_tokens#destroy'
  resources :articles, only: [:index, :show, :create]
end
