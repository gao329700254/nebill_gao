Rails.application.routes.draw do
  namespace :api, format: :json do
    resources :projects, only: [:index, :create, :show, :update]
  end
end
