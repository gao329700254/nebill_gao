# == Route Map
#
#       Prefix Verb URI Pattern             Controller#Action
#     teaspoon      /teaspoon               Teaspoon::Engine
#         root GET  /                       pages#home
#         home GET  /home(.:format)         pages#home
# api_projects GET  /api/projects(.:format) api/projects#index
#              POST /api/projects(.:format) api/projects#create
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

  namespace :api, format: :json do
    resources :projects, only: [:index, :create]
  end
end
