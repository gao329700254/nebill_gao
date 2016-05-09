Rails.application.routes.draw do
  namespace :api, format: :json do
    resources :users, only: [:create]
    resources :projects, only: [:index, :create, :show, :update], shallow: true do
      resources :bills, only: [:create, :show, :update]
    end
    resources :project_groups, only: [:index, :create, :update]
    resources :bills, only: [:index]
  end
end
