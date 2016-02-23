Rails.application.routes.draw do
  namespace :api, format: :json do
    resources :projects, only: [:index, :create, :show, :update]
    resources :project_groups, only: [:index, :create, :update]
  end
end
