Rails.application.routes.draw do
  namespace :api, format: :json do
    resources :clients, only: [:index, :create, :show, :update]
    resources :users, only: [:index, :create, :show, :update, :destroy], shallow: true do
      collection do
        get 'roles', to: "users#roles"
      end
    end
    resources :partners, only: [:index, :create, :update]
    post "projects/create_with_client", to: "projects#create_with_client"
    resources :projects, only: [:index, :create, :show, :update, :destroy], shallow: true do
      collection do
        get ':id/select_status', to: "projects#select_status"
        get ':id/last_updated_at', to: "projects#last_updated_at"
      end
      collection do
        get 'bill/:bill_id', to: "projects#show"
      end
      resources :users, only: [:index]
      resources :bills, only: [:index, :create, :show, :update, :destroy], shallow: true do
        resources :partners, only: [:index]
        resources :users, only: [:index]
      end
      resources :partners, only: [:index]
      resources :project_files, only: [:index, :show, :create, :update, :destroy]
      resources :project_file_groups, only: [:index, :create]
      get 'bill_default_values', on: :member
      collection do
        get "cd/:project_type", to: "project_cds#cd", as: "project_cd"
      end
    end
    %w(user partner).each do |member_type|
      post "#{member_type}_members/:bill_id/:#{member_type}_id", to: "#{member_type}_members#create", as: "#{member_type}_members"
      delete "#{member_type}_members/:bill_id/:#{member_type}_id", to: "#{member_type}_members#destroy", as: "delete_#{member_type}_members"
    end
    patch "partner_members/:bill_id/:partner_id", to: "partner_members#update", as: "update_partner_members"
    resources :project_groups, only: [:index, :create, :update]
    resources :bills, only: [:index]
    post "projects/search_result", to: "projects#search_result"
    post "bills/search_result", to: "bills#search_result"
    post "approvals/search_result", to: "approvals#search_result"
    resources :approvals, only: [:show, :create, :update, :destroy, :index]
    scope path: 'files/:files_id' do
      get 'approval_file_download', to: 'files#approval_file_download'
    end
    resources :expenses, only: [:show, :create, :update, :destroy, :index], shallow: true do
      collection do
        get 'set_default_items', to: "expenses#set_default_items"
      end
    end
    scope path: 'expenses' do
      post "input_item", to: "expenses#input_item"
      post "load_item", to: "expenses#load_item"
      post "load_list", to: "expenses#load_list"
      post "reapproval", to: "expenses#reapproval"
      post "invalid_approval", to: "expenses#invalid_approval"
      post "create_expense_approval", to: "expenses#create_expense_approval"
      post "search_for_csv", to: "expenses#search_for_csv"
      post "expense_history", to: "expenses#expense_history"
      post "set_project", to: "expenses#set_project"
      post "expense_transportation", to: "expenses#expense_transportation"
      post "load_expense", to: "expenses#load_expense"
    end
    scope path: 'files/:files_id' do
      get 'expense_file_download', to: 'files#expense_file_download'
    end
    post "expense_approvals/search_result", to: "expense_approvals#search_result"
    resources :expense_approvals, only: [:show, :create, :update, :destroy, :index]
  end
end
