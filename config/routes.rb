# == Route Map
#
#             Prefix Verb  URI Pattern                          Controller#Action
#           teaspoon       /teaspoon                            Teaspoon::Engine
#               root GET   /                                    pages#home
#               home GET   /home(.:format)                      pages#home
#        project_new GET   /projects/new(.:format)              pages#project_new
#       project_list GET   /projects/list(.:format)             pages#project_list
#       project_show GET   /projects/:project_id/show(.:format) pages#project_show
#       api_projects GET   /api/projects(.:format)              api/projects#index
#                    POST  /api/projects(.:format)              api/projects#create
#        api_project GET   /api/projects/:id(.:format)          api/projects#show
#                    PATCH /api/projects/:id(.:format)          api/projects#update
#                    PUT   /api/projects/:id(.:format)          api/projects#update
# api_project_groups GET   /api/project_groups(.:format)        api/project_groups#index
#                    POST  /api/project_groups(.:format)        api/project_groups#create
#  api_project_group PATCH /api/project_groups/:id(.:format)    api/project_groups#update
#                    PUT   /api/project_groups/:id(.:format)    api/project_groups#update
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
  scope path: 'projects' do
    get 'new', to: 'pages#project_new', as: 'project_new'
    get 'list', to: 'pages#project_list', as: 'project_list'
  end
  scope path: 'projects/:project_id' do
    get 'show', to: 'pages#project_show', as: 'project_show'
  end
end
