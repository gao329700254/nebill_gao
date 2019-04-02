Rails.application.routes.draw do
  namespace :api, format: :json do
    resources :clients, only: [:index, :create, :show, :update], shallow: true do
      collection do
        get 'statuses', to: "clients#statuses"
        get 'published_clients', to: "clients#published_clients"
        post 'set_approval_user', to: "clients#set_approval_user"
      end
    end
    scope path: 'files/:files_id' do
      get 'client_file_download', to: 'files#client_file_download'
    end
    scope path: 'clients/:client_id' do
      post "update_approval", to: "clients#update_approval"
      post "invalid_client", to: "clients#invalid_client"
    end
    resources :approval_groups
    resources :clients, only: [:index, :create, :show, :update]
    resources :users, only: [:index, :create, :show, :update, :destroy], shallow: true do
      resources :send_password_setting_emails, only: [:create]
      collection do
        get 'roles', to: "users#roles"
      end
    end
    resources :partners, only: [:index, :create, :update]
    resources :projects, only: [:index, :create, :show, :update, :destroy], shallow: true do
      collection do
        get ':id/select_status', to: "projects#select_status"
        get ':id/last_updated_at', to: "projects#last_updated_at"
        get 'load_partner_user', to: "projects#load_partner_user"
        post ':id/member_partner', to: "projects#member_partner"
      end
      collection do
        get 'bill/:bill_id', to: "projects#show"
      end
      resources :users, only: [:index]
      resources :bills, only: [:index, :create, :show, :update, :destroy]
      resources :partners, only: [:index]
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
    patch "user_members/:project_id/:user_id", to: "user_members#update", as: "update_user_members"
    resources :project_groups, only: [:index, :create, :update]
    resources :bills, only: [:index]
    post "projects/search_result", to: "projects#search_result"
    post "bills/search_result", to: "bills#search_result"
    post "approvals_search/index", to: "approvals_search#index"
    resources :approvals, only: [:show, :create, :update, :destroy, :index] do
      post "invalid", to: "approvals#invalid"
      resources :approval_users, only: [:create, :update]
      post "search/index", to: "approvals_search#index"
    end
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
    scope path: 'agreements' do
      get "approval_list", to: "agreements#approval_list"
      get "client_list", to: "agreements#client_list"
      get "project_list", to: "agreements#project_list"
      get "expense_approval_list", to: "agreements#expense_approval_list"
    end
  end
end
