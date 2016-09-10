Rails.application.routes.draw do
  namespace :api, format: :json do
    resources :clients, only: [:index, :create, :show]
    resources :users, only: [:index, :create]
    resources :partners, only: [:index, :create]
    resources :projects, only: [:index, :create, :show, :update], shallow: true do
      resources :users, only: [:index]
      resources :partners, only: [:index]
      resources :bills, only: [:create, :show, :update]
      resources :project_files, only: [:index, :create]
      get 'default_dates', on: :member
    end
    %w(user partner).each do |member_type|
      post "#{member_type}_members/:project_id/:#{member_type}_id", to: "#{member_type}_members#create", as: "#{member_type}_members"
    end
    resources :project_groups, only: [:index, :create, :update]
    resources :bills, only: [:index]
  end
end
