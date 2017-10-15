# == Route Map
#
#                          Prefix Verb   URI Pattern                                             Controller#Action
#                        teaspoon        /teaspoon                                               Teaspoon::Engine
#                            root GET    /                                                       pages#home
#                            home GET    /home(.:format)                                         pages#home
#                                 GET    /auth/:provider/callback(.:format)                      user_sessions#create
#                                 POST   /auth/:provider/callback(.:format)                      user_sessions#create
#                          logout DELETE /logout(.:format)                                       user_sessions#destroy
#                     client_list GET    /clients/list(.:format)                                 pages#client_list
#                     client_show GET    /clients/:client_id/show(.:format)                      pages#client_show
#                    project_list GET    /projects/list(.:format)                                pages#project_list
#                    project_show GET    /projects/:project_id/show(.:format)                    pages#project_show
#                       bill_list GET    /bills/list(.:format)                                   pages#bill_list
#                       bill_show GET    /bills/:bill_id/show(.:format)                          pages#bill_show
#                   bill_download GET    /bills/:bill_id/xlsx(.:format)                          bills/xlsx#download
#               bill_download_pdf GET    /bills/:bill_id/pdf(.:format)                           bills/pdf#download
#                  project_groups GET    /project_groups(.:format)                               pages#project_groups
#                        partners GET    /partners(.:format)                                     pages#partners
#                     admin_users GET    /admin/users(.:format)                                  admin/pages#users
#                     api_clients GET    /api/clients(.:format)                                  api/clients#index
#                                 POST   /api/clients(.:format)                                  api/clients#create
#                      api_client GET    /api/clients/:id(.:format)                              api/clients#show
#                                 PATCH  /api/clients/:id(.:format)                              api/clients#update
#                                 PUT    /api/clients/:id(.:format)                              api/clients#update
#                       api_users GET    /api/users(.:format)                                    api/users#index
#                                 POST   /api/users(.:format)                                    api/users#create
#                    api_partners GET    /api/partners(.:format)                                 api/partners#index
#                                 POST   /api/partners(.:format)                                 api/partners#create
#                     api_partner PATCH  /api/partners/:id(.:format)                             api/partners#update
#                                 PUT    /api/partners/:id(.:format)                             api/partners#update
# api_projects_create_with_client POST   /api/projects/create_with_client(.:format)              api/projects#create_with_client
#                                 GET    /api/projects/:id/select_status(.:format)               api/projects#select_status
#                                 GET    /api/projects/:id/last_updated_at(.:format)             api/projects#last_updated_at
#                                 GET    /api/projects/bill/:bill_id(.:format)                   api/projects#show
#               api_project_users GET    /api/projects/:project_id/users(.:format)               api/users#index
#               api_bill_partners GET    /api/bills/:bill_id/partners(.:format)                  api/partners#index
#                  api_bill_users GET    /api/bills/:bill_id/users(.:format)                     api/users#index
#               api_project_bills GET    /api/projects/:project_id/bills(.:format)               api/bills#index
#                                 POST   /api/projects/:project_id/bills(.:format)               api/bills#create
#                        api_bill GET    /api/bills/:id(.:format)                                api/bills#show
#                                 PATCH  /api/bills/:id(.:format)                                api/bills#update
#                                 PUT    /api/bills/:id(.:format)                                api/bills#update
#                                 DELETE /api/bills/:id(.:format)                                api/bills#destroy
#            api_project_partners GET    /api/projects/:project_id/partners(.:format)            api/partners#index
#       api_project_project_files GET    /api/projects/:project_id/project_files(.:format)       api/project_files#index
#                                 POST   /api/projects/:project_id/project_files(.:format)       api/project_files#create
#                api_project_file GET    /api/project_files/:id(.:format)                        api/project_files#show
#                                 PATCH  /api/project_files/:id(.:format)                        api/project_files#update
#                                 PUT    /api/project_files/:id(.:format)                        api/project_files#update
#                                 DELETE /api/project_files/:id(.:format)                        api/project_files#destroy
# api_project_project_file_groups GET    /api/projects/:project_id/project_file_groups(.:format) api/project_file_groups#index
#                                 POST   /api/projects/:project_id/project_file_groups(.:format) api/project_file_groups#create
# bill_default_values_api_project GET    /api/projects/:id/bill_default_values(.:format)         api/projects#bill_default_values
#         project_cd_api_projects GET    /api/projects/cd/:project_type(.:format)                api/project_cds#cd
#                    api_projects GET    /api/projects(.:format)                                 api/projects#index
#                                 POST   /api/projects(.:format)                                 api/projects#create
#                     api_project GET    /api/projects/:id(.:format)                             api/projects#show
#                                 PATCH  /api/projects/:id(.:format)                             api/projects#update
#                                 PUT    /api/projects/:id(.:format)                             api/projects#update
#                                 DELETE /api/projects/:id(.:format)                             api/projects#destroy
#                api_user_members POST   /api/user_members/:bill_id/:user_id(.:format)           api/user_members#create
#         api_delete_user_members DELETE /api/user_members/:bill_id/:user_id(.:format)           api/user_members#destroy
#             api_partner_members POST   /api/partner_members/:bill_id/:partner_id(.:format)     api/partner_members#create
#      api_delete_partner_members DELETE /api/partner_members/:bill_id/:partner_id(.:format)     api/partner_members#destroy
#      api_update_partner_members PATCH  /api/partner_members/:bill_id/:partner_id(.:format)     api/partner_members#update
#              api_project_groups GET    /api/project_groups(.:format)                           api/project_groups#index
#                                 POST   /api/project_groups(.:format)                           api/project_groups#create
#               api_project_group PATCH  /api/project_groups/:id(.:format)                       api/project_groups#update
#                                 PUT    /api/project_groups/:id(.:format)                       api/project_groups#update
#                       api_bills GET    /api/bills(.:format)                                    api/bills#index
#      api_projects_search_result POST   /api/projects/search_result(.:format)                   api/projects#search_result
#         api_bills_search_result POST   /api/bills/search_result(.:format)                      api/bills#search_result
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
    get 'list', to: 'pages#client_list', as: 'client_list'
  end
  scope path: 'clients/:client_id' do
    get 'show', to: 'pages#client_show', as: 'client_show'
  end
  scope path: 'projects' do
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
    get 'pdf', to: 'bills/pdf#download', as: 'bill_download_pdf'
  end
  get 'project_groups', to: 'pages#project_groups'
  get 'partners'      , to: 'pages#partners'

  namespace :admin do
    get 'users', to: 'pages#users'
  end
end
