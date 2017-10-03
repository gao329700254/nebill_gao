Rails.application.routes.draw do
  namespace :api, format: :json do
    resources :clients, only: [:index, :create, :show, :update]
    resources :users, only: [:index, :create]
    resources :partners, only: [:index, :create]
    resources :projects, only: [:index, :create, :show, :update, :destroy], shallow: true do
      collection do
        get ':id/select_status', to: "projects#select_status"
      end
      resources :users, only: [:index]
      resources :partners, only: [:index]
      resources :bills, only: [:index, :create, :show, :update, :destroy]
      resources :project_files, only: [:index, :show, :create, :update, :destroy]
      resources :project_file_groups, only: [:index, :create]
      get 'bill_default_values', on: :member
      collection do
        get "cd/:project_type", to: "project_cds#cd", as: "project_cd"
      end
    end
    %w(user partner).each do |member_type|
      post "#{member_type}_members/:project_id/:#{member_type}_id", to: "#{member_type}_members#create", as: "#{member_type}_members"
      delete "#{member_type}_members/:project_id/:#{member_type}_id", to: "#{member_type}_members#destroy", as: "delete_#{member_type}_members"
    end
    patch "partner_members/:project_id/:partner_id", to: "partner_members#update", as: "update_partner_members"
    resources :project_groups, only: [:index, :create, :update]
    resources :bills, only: [:index]
  end
end
