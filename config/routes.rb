# == Route Map
#
#                          Prefix Verb   URI Pattern                                             Controller#Action
#                        teaspoon        /teaspoon                                               Teaspoon::Engine
#                            root GET    /                                                       pages#home
#                            home GET    /home(.:format)                                         pages#home
#                                 GET    /auth/:provider/callback(.:format)                      user_sessions#create
#                                 POST   /auth/:provider/callback(.:format)                      user_sessions#create
#                          logout DELETE /logout(.:format)                                       user_sessions#destroy
#                      client_new GET    /clients/new(.:format)                                  pages#client_new
#                     client_list GET    /clients/list(.:format)                                 pages#client_list
#                     project_new GET    /projects/new(.:format)                                 pages#project_new
#                    project_list GET    /projects/list(.:format)                                pages#project_list
#                    project_show GET    /projects/:project_id/show(.:format)                    pages#project_show
#                       bill_list GET    /bills/list(.:format)                                   pages#bill_list
#                       bill_show GET    /bills/:bill_id/show(.:format)                          pages#bill_show
#                   bill_download GET    /bills/:bill_id/xlsx(.:format)                          bills/xlsx#download
#                  project_groups GET    /project_groups(.:format)                               pages#project_groups
#                        partners GET    /partners(.:format)                                     pages#partners
#                     admin_users GET    /admin/users(.:format)                                  admin/pages#users
#                     api_clients GET    /api/clients(.:format)                                  api/clients#index
#                                 POST   /api/clients(.:format)                                  api/clients#create
#                      api_client GET    /api/clients/:id(.:format)                              api/clients#show
#                       api_users GET    /api/users(.:format)                                    api/users#index
#                                 POST   /api/users(.:format)                                    api/users#create
#                    api_partners GET    /api/partners(.:format)                                 api/partners#index
#                                 POST   /api/partners(.:format)                                 api/partners#create
#               api_project_users GET    /api/projects/:project_id/users(.:format)               api/users#index
#            api_project_partners GET    /api/projects/:project_id/partners(.:format)            api/partners#index
#               api_project_bills POST   /api/projects/:project_id/bills(.:format)               api/bills#create
#                        api_bill GET    /api/bills/:id(.:format)                                api/bills#show
#                                 PATCH  /api/bills/:id(.:format)                                api/bills#update
#                                 PUT    /api/bills/:id(.:format)                                api/bills#update
#       api_project_project_files GET    /api/projects/:project_id/project_files(.:format)       api/project_files#index
#                                 POST   /api/projects/:project_id/project_files(.:format)       api/project_files#create
#                api_project_file PATCH  /api/project_files/:id(.:format)                        api/project_files#update
#                                 PUT    /api/project_files/:id(.:format)                        api/project_files#update
# api_project_project_file_groups GET    /api/projects/:project_id/project_file_groups(.:format) api/project_file_groups#index
#                                 POST   /api/projects/:project_id/project_file_groups(.:format) api/project_file_groups#create
#       default_dates_api_project GET    /api/projects/:id/default_dates(.:format)               api/projects#default_dates
#        project_key_api_projects GET    /api/projects/key/:project_type(.:format)               api/project_keys#key
#                    api_projects GET    /api/projects(.:format)                                 api/projects#index
#                                 POST   /api/projects(.:format)                                 api/projects#create
#                     api_project GET    /api/projects/:id(.:format)                             api/projects#show
#                                 PATCH  /api/projects/:id(.:format)                             api/projects#update
#                                 PUT    /api/projects/:id(.:format)                             api/projects#update
#                api_user_members POST   /api/user_members/:project_id/:user_id(.:format)        api/user_members#create
#             api_partner_members POST   /api/partner_members/:project_id/:partner_id(.:format)  api/partner_members#create
#              api_project_groups GET    /api/project_groups(.:format)                           api/project_groups#index
#                                 POST   /api/project_groups(.:format)                           api/project_groups#create
#               api_project_group PATCH  /api/project_groups/:id(.:format)                       api/project_groups#update
#                                 PUT    /api/project_groups/:id(.:format)                       api/project_groups#update
#                       api_bills GET    /api/bills(.:format)                                    api/bills#index
#
# Routes for Teaspoon::Engine:
#    root GET  /                             teaspoon/suite#index
# fixture GET  /fixtures/*filename(.:format) teaspoon/suite#fixtures
#   suite GET  /:suite(.:format)             teaspoon/suite#show {:suite=>"default"}
#         POST /:suite/:hook(.:format)       teaspoon/suite#hook {:suite=>"default", :hook=>"default"}
#

Rails.application.routes.draw do
  root 'pages#home'

  get 'home', to: 'pages#home'

  get    '/auth/:provider/callback', to: 'user_sessions#create'
  post   '/auth/:provider/callback', to: 'user_sessions#create'
  delete '/logout'                 , to: 'user_sessions#destroy'

  scope path: 'clients' do
    get 'new',  to: 'pages#client_new',  as: 'client_new'
    get 'list', to: 'pages#client_list', as: 'client_list'
  end
  scope path: 'projects' do
    get 'new', to: 'pages#project_new', as: 'project_new'
    get 'list', to: 'pages#project_list', as: 'project_list'
  end
  scope path: 'projects/:project_id' do
    get 'show', to: 'pages#project_show', as: 'project_show'
  end
  scope path: 'bills' do
    get 'list', to: 'pages#bill_list', as: 'bill_list'
  end
  scope path: 'bills/:bill_id' do
    get 'show', to: 'pages#bill_show', as: 'bill_show'
    get 'xlsx', to: 'bills/xlsx#download', as: 'bill_download'
  end
  get 'project_groups', to: 'pages#project_groups'
  get 'partners'      , to: 'pages#partners'

  namespace :admin do
    get 'users', to: 'pages#users'
  end
end
