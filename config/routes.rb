# == Route Map
#
#             Prefix Verb   URI Pattern                          Controller#Action
#           teaspoon        /teaspoon                            Teaspoon::Engine
#               root GET    /                                    pages#home
#               home GET    /home(.:format)                      pages#home
#                    GET    /auth/:provider/callback(.:format)   user_sessions#create
#                    POST   /auth/:provider/callback(.:format)   user_sessions#create
#             logout DELETE /logout(.:format)                    user_sessions#destroy
#        project_new GET    /projects/new(.:format)              pages#project_new
#       project_list GET    /projects/list(.:format)             pages#project_list
#       project_show GET    /projects/:project_id/show(.:format) pages#project_show
#     project_groups GET    /project_groups(.:format)            pages#project_groups
#        admin_users GET    /admin/users(.:format)               admin/pages#users
#          api_users POST   /api/users(.:format)                 api/users#create
#       api_projects GET    /api/projects(.:format)              api/projects#index
#                    POST   /api/projects(.:format)              api/projects#create
#        api_project GET    /api/projects/:id(.:format)          api/projects#show
#                    PATCH  /api/projects/:id(.:format)          api/projects#update
#                    PUT    /api/projects/:id(.:format)          api/projects#update
# api_project_groups GET    /api/project_groups(.:format)        api/project_groups#index
#                    POST   /api/project_groups(.:format)        api/project_groups#create
#  api_project_group PATCH  /api/project_groups/:id(.:format)    api/project_groups#update
#                    PUT    /api/project_groups/:id(.:format)    api/project_groups#update
#          api_bills GET    /api/bills(.:format)                 api/bills#index
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

  scope path: 'projects' do
    get 'new', to: 'pages#project_new', as: 'project_new'
    get 'list', to: 'pages#project_list', as: 'project_list'
  end
  scope path: 'projects/:project_id' do
    get 'show', to: 'pages#project_show', as: 'project_show'
  end
  get 'project_groups', to: 'pages#project_groups'

  namespace :admin do
    get 'users', to: 'pages#users'
  end
end
