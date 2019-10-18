# == Route Map
#
#                                Prefix Verb   URI Pattern                                                 Controller#Action
#                              teaspoon        /teaspoon                                                   Teaspoon::Engine
#                       approval_groups GET    /approval_groups(.:format)                                  approval_groups#index
#                                       POST   /approval_groups(.:format)                                  approval_groups#create
#                    new_approval_group GET    /approval_groups/new(.:format)                              approval_groups#new
#                   edit_approval_group GET    /approval_groups/:id/edit(.:format)                         approval_groups#edit
#                        approval_group GET    /approval_groups/:id(.:format)                              approval_groups#show
#                                       PATCH  /approval_groups/:id(.:format)                              approval_groups#update
#                                       PUT    /approval_groups/:id(.:format)                              approval_groups#update
#                                       DELETE /approval_groups/:id(.:format)                              approval_groups#destroy
#                                  root GET    /                                                           pages#home
#                                  home GET    /home(.:format)                                             pages#home
#                                 hooks POST   /hooks(.:format)                                            hooks#create
#                         user_sessions GET    /user_sessions(.:format)                                    user_sessions#index
#                                       POST   /user_sessions(.:format)                                    user_sessions#create
#                      new_user_session GET    /user_sessions/new(.:format)                                user_sessions#new
#                     edit_user_session GET    /user_sessions/:id/edit(.:format)                           user_sessions#edit
#                          user_session GET    /user_sessions/:id(.:format)                                user_sessions#show
#                                       PATCH  /user_sessions/:id(.:format)                                user_sessions#update
#                                       PUT    /user_sessions/:id(.:format)                                user_sessions#update
#                                       DELETE /user_sessions/:id(.:format)                                user_sessions#destroy
#                     password_settings GET    /password_settings(.:format)                                password_settings#index
#                                       POST   /password_settings(.:format)                                password_settings#create
#                  new_password_setting GET    /password_settings/new(.:format)                            password_settings#new
#                 edit_password_setting GET    /password_settings/:id/edit(.:format)                       password_settings#edit
#                      password_setting GET    /password_settings/:id(.:format)                            password_settings#show
#                                       PATCH  /password_settings/:id(.:format)                            password_settings#update
#                                       PUT    /password_settings/:id(.:format)                            password_settings#update
#                                       DELETE /password_settings/:id(.:format)                            password_settings#destroy
#                                       GET    /auth/:provider/callback(.:format)                          user_sessions#create
#                                       POST   /auth/:provider/callback(.:format)                          user_sessions#create
#                                logout DELETE /logout(.:format)                                           user_sessions#destroy
#                           client_list GET    /clients/list(.:format)                                     pages#client_list
#                           client_show GET    /clients/:client_id/show(.:format)                          pages#client_show
#                          project_list GET    /projects/list(.:format)                                    pages#project_list
#                          project_show GET    /projects/:project_id/show(.:format)                        pages#project_show
#                          approval_new GET    /approvals/new(.:format)                                    pages#approval_new
#                         approval_list GET    /approvals/list(.:format)                                   pages#approval_list
#                         approval_show GET    /approvals/:approval_id/show(.:format)                      pages#approval_show
#                         approval_edit GET    /approvals/:approval_id/edit(.:format)                      pages#approval_edit
#                           expense_new GET    /expense/new(.:format)                                      pages#expense_new
#                          expense_list GET    /expense/list(.:format)                                     pages#expense_list
#                      expense_download GET    /expense/pdf(.:format)                                      expenses/pdf#download
#                           expense_csv GET    /expense/csv(.:format)                                      pages#expense_csv
#                  expense_download_csv POST   /expense/tocsv(.:format)                                    expenses/csv#download_csv
#                          expense_edit GET    /expense/:expense_id/edit(.:format)                         pages#expense_edit
#                  expense_download_pdf GET    /expense/:expense_id/pdf(.:format)                          expenses/pdf#download
#                  expense_approval_new GET    /expense/approval/new(.:format)                             pages#expense_approval_new
#                 expense_approval_list GET    /expense/approval/list(.:format)                            pages#expense_approval_list
#                 expense_approval_show GET    /expense/approval/:expense_approval_id/show(.:format)       pages#expense_approval_show
#                 expense_approval_edit GET    /expense/approval/:expense_approval_id/edit(.:format)       pages#expense_approval_edit
#                             bill_list GET    /bills/list(.:format)                                       pages#bill_list
#                             bill_show GET    /bills/:bill_id/show(.:format)                              pages#bill_show
#                         bill_download GET    /bills/:bill_id/xlsx(.:format)                              bills/xlsx#download
#                     bill_download_pdf GET    /bills/:bill_id/pdf(.:format)                               bills/pdf#download
#                        project_groups GET    /project_groups(.:format)                                   pages#project_groups
#                              partners GET    /partners(.:format)                                         pages#partners
#                        agreement_list GET    /agreements/list(.:format)                                  pages#agreement_list
#                           admin_users GET    /admin/users(.:format)                                      admin/pages#users
#                  admin_fb_date_output GET    /admin/fb_date_output(.:format)                             admin/pages#fb_date_output
#                 admin_fb_download_csv POST   /admin/fb_download_csv(.:format)                            admin/fb#fb_download_csv
#                       admin_user_show GET    /admin/users/:user_id/show(.:format)                        admin/pages#user_show
#                     letter_opener_web        /letter_opener                                              LetterOpenerWeb::Engine
#                  statuses_api_clients GET    /api/clients/statuses(.:format)                             api/clients#statuses
#         published_clients_api_clients GET    /api/clients/published_clients(.:format)                    api/clients#published_clients
#         set_approval_user_api_clients POST   /api/clients/set_approval_user(.:format)                    api/clients#set_approval_user
#                           api_clients GET    /api/clients(.:format)                                      api/clients#index
#                                       POST   /api/clients(.:format)                                      api/clients#create
#                            api_client GET    /api/clients/:id(.:format)                                  api/clients#show
#                                       PATCH  /api/clients/:id(.:format)                                  api/clients#update
#                                       PUT    /api/clients/:id(.:format)                                  api/clients#update
#              api_client_file_download GET    /api/files/:files_id/client_file_download(.:format)         api/files#client_file_download
#                   api_update_approval POST   /api/clients/:client_id/update_approval(.:format)           api/clients#update_approval
#                    api_invalid_client POST   /api/clients/:client_id/invalid_client(.:format)            api/clients#invalid_client
#                   api_approval_groups GET    /api/approval_groups(.:format)                              api/approval_groups#index
#                                       POST   /api/approval_groups(.:format)                              api/approval_groups#create
#                new_api_approval_group GET    /api/approval_groups/new(.:format)                          api/approval_groups#new
#               edit_api_approval_group GET    /api/approval_groups/:id/edit(.:format)                     api/approval_groups#edit
#                    api_approval_group GET    /api/approval_groups/:id(.:format)                          api/approval_groups#show
#                                       PATCH  /api/approval_groups/:id(.:format)                          api/approval_groups#update
#                                       PUT    /api/approval_groups/:id(.:format)                          api/approval_groups#update
#                                       DELETE /api/approval_groups/:id(.:format)                          api/approval_groups#destroy
#                                       GET    /api/clients(.:format)                                      api/clients#index
#                                       POST   /api/clients(.:format)                                      api/clients#create
#                                       GET    /api/clients/:id(.:format)                                  api/clients#show
#                                       PATCH  /api/clients/:id(.:format)                                  api/clients#update
#                                       PUT    /api/clients/:id(.:format)                                  api/clients#update
# api_user_send_password_setting_emails POST   /api/users/:user_id/send_password_setting_emails(.:format)  api/send_password_setting_emails#create
#                       roles_api_users GET    /api/users/roles(.:format)                                  api/users#roles
#                             api_users GET    /api/users(.:format)                                        api/users#index
#                                       POST   /api/users(.:format)                                        api/users#create
#                              api_user GET    /api/users/:id(.:format)                                    api/users#show
#                                       PATCH  /api/users/:id(.:format)                                    api/users#update
#                                       PUT    /api/users/:id(.:format)                                    api/users#update
#                                       DELETE /api/users/:id(.:format)                                    api/users#destroy
#                          api_partners GET    /api/partners(.:format)                                     api/partners#index
#                                       POST   /api/partners(.:format)                                     api/partners#create
#                           api_partner PATCH  /api/partners/:id(.:format)                                 api/partners#update
#                                       PUT    /api/partners/:id(.:format)                                 api/partners#update
#                                       GET    /api/projects/:id/select_status(.:format)                   api/projects#select_status
#                                       GET    /api/projects/:id/last_updated_at(.:format)                 api/projects#last_updated_at
#        load_partner_user_api_projects GET    /api/projects/load_partner_user(.:format)                   api/projects#load_partner_user
#                                       POST   /api/projects/:id/member_partner(.:format)                  api/projects#member_partner
#                                       GET    /api/projects/bill/:bill_id(.:format)                       api/projects#show
#                     api_project_users GET    /api/projects/:project_id/users(.:format)                   api/users#index
#                     api_project_bills GET    /api/projects/:project_id/bills(.:format)                   api/bills#index
#                                       POST   /api/projects/:project_id/bills(.:format)                   api/bills#create
#                              api_bill GET    /api/bills/:id(.:format)                                    api/bills#show
#                                       PATCH  /api/bills/:id(.:format)                                    api/bills#update
#                                       PUT    /api/bills/:id(.:format)                                    api/bills#update
#                                       DELETE /api/bills/:id(.:format)                                    api/bills#destroy
#                  api_project_partners GET    /api/projects/:project_id/partners(.:format)                api/partners#index
#             api_project_project_files GET    /api/projects/:project_id/project_files(.:format)           api/project_files#index
#                                       POST   /api/projects/:project_id/project_files(.:format)           api/project_files#create
#                      api_project_file GET    /api/project_files/:id(.:format)                            api/project_files#show
#                                       PATCH  /api/project_files/:id(.:format)                            api/project_files#update
#                                       PUT    /api/project_files/:id(.:format)                            api/project_files#update
#                                       DELETE /api/project_files/:id(.:format)                            api/project_files#destroy
#       api_project_project_file_groups GET    /api/projects/:project_id/project_file_groups(.:format)     api/project_file_groups#index
#                                       POST   /api/projects/:project_id/project_file_groups(.:format)     api/project_file_groups#create
#       bill_default_values_api_project GET    /api/projects/:id/bill_default_values(.:format)             api/projects#bill_default_values
#                create_cd_api_projects GET    /api/projects/create_cd/:project_type(.:format)             api/project_cds#create_cd
#                          api_projects GET    /api/projects(.:format)                                     api/projects#index
#                                       POST   /api/projects(.:format)                                     api/projects#create
#                           api_project GET    /api/projects/:id(.:format)                                 api/projects#show
#                                       PATCH  /api/projects/:id(.:format)                                 api/projects#update
#                                       PUT    /api/projects/:id(.:format)                                 api/projects#update
#                                       DELETE /api/projects/:id(.:format)                                 api/projects#destroy
#           api_update_project_approval POST   /api/projects/:project_id/update_project_approval(.:format) api/projects#update_project_approval
#                      api_user_members POST   /api/user_members/:project_id/:user_id(.:format)            api/user_members#create
#               api_delete_user_members DELETE /api/user_members/:project_id/:user_id(.:format)            api/user_members#destroy
#                   api_partner_members POST   /api/partner_members/:project_id/:partner_id(.:format)      api/partner_members#create
#            api_delete_partner_members DELETE /api/partner_members/:project_id/:partner_id(.:format)      api/partner_members#destroy
#            api_update_partner_members PATCH  /api/partner_members/:project_id/:partner_id(.:format)      api/partner_members#update
#               api_update_user_members PATCH  /api/user_members/:project_id/:user_id(.:format)            api/user_members#update
#                    api_project_groups GET    /api/project_groups(.:format)                               api/project_groups#index
#                                       POST   /api/project_groups(.:format)                               api/project_groups#create
#                     api_project_group PATCH  /api/project_groups/:id(.:format)                           api/project_groups#update
#                                       PUT    /api/project_groups/:id(.:format)                           api/project_groups#update
#                             api_bills GET    /api/bills(.:format)                                        api/bills#index
#            api_projects_search_result POST   /api/projects/search_result(.:format)                       api/projects#search_result
#               api_bills_search_result POST   /api/bills/search_result(.:format)                          api/bills#search_result
#            api_approvals_search_index POST   /api/approvals_search/index(.:format)                       api/approvals_search#index
#                  api_approval_invalid POST   /api/approvals/:approval_id/invalid(.:format)               api/approvals#invalid
#           api_approval_approval_users POST   /api/approvals/:approval_id/approval_users(.:format)        api/approval_users#create
#            api_approval_approval_user PATCH  /api/approvals/:approval_id/approval_users/:id(.:format)    api/approval_users#update
#                                       PUT    /api/approvals/:approval_id/approval_users/:id(.:format)    api/approval_users#update
#             api_approval_search_index POST   /api/approvals/:approval_id/search/index(.:format)          api/approvals_search#index
#                         api_approvals GET    /api/approvals(.:format)                                    api/approvals#index
#                                       POST   /api/approvals(.:format)                                    api/approvals#create
#                          api_approval GET    /api/approvals/:id(.:format)                                api/approvals#show
#                                       PATCH  /api/approvals/:id(.:format)                                api/approvals#update
#                                       PUT    /api/approvals/:id(.:format)                                api/approvals#update
#                                       DELETE /api/approvals/:id(.:format)                                api/approvals#destroy
#            api_approval_file_download GET    /api/files/:files_id/approval_file_download(.:format)       api/files#approval_file_download
#        set_default_items_api_expenses GET    /api/expenses/set_default_items(.:format)                   api/expenses#set_default_items
#                          api_expenses GET    /api/expenses(.:format)                                     api/expenses#index
#                                       POST   /api/expenses(.:format)                                     api/expenses#create
#                           api_expense GET    /api/expenses/:id(.:format)                                 api/expenses#show
#                                       PATCH  /api/expenses/:id(.:format)                                 api/expenses#update
#                                       PUT    /api/expenses/:id(.:format)                                 api/expenses#update
#                                       DELETE /api/expenses/:id(.:format)                                 api/expenses#destroy
#                        api_input_item POST   /api/expenses/input_item(.:format)                          api/expenses#input_item
#                         api_load_item POST   /api/expenses/load_item(.:format)                           api/expenses#load_item
#                         api_load_list POST   /api/expenses/load_list(.:format)                           api/expenses#load_list
#                        api_reapproval POST   /api/expenses/reapproval(.:format)                          api/expenses#reapproval
#                  api_invalid_approval POST   /api/expenses/invalid_approval(.:format)                    api/expenses#invalid_approval
#           api_create_expense_approval POST   /api/expenses/create_expense_approval(.:format)             api/expenses#create_expense_approval
#                    api_search_for_csv POST   /api/expenses/search_for_csv(.:format)                      api/expenses#search_for_csv
#                   api_expense_history POST   /api/expenses/expense_history(.:format)                     api/expenses#expense_history
#                       api_set_project POST   /api/expenses/set_project(.:format)                         api/expenses#set_project
#            api_expense_transportation POST   /api/expenses/expense_transportation(.:format)              api/expenses#expense_transportation
#                      api_load_expense POST   /api/expenses/load_expense(.:format)                        api/expenses#load_expense
#             api_expense_file_download GET    /api/files/:files_id/expense_file_download(.:format)        api/files#expense_file_download
#                 api_expense_approvals GET    /api/expense_approvals(.:format)                            api/expense_approvals#index
#                                       POST   /api/expense_approvals(.:format)                            api/expense_approvals#create
#                  api_expense_approval GET    /api/expense_approvals/:id(.:format)                        api/expense_approvals#show
#                                       PATCH  /api/expense_approvals/:id(.:format)                        api/expense_approvals#update
#                                       PUT    /api/expense_approvals/:id(.:format)                        api/expense_approvals#update
#                     api_approval_list GET    /api/agreements/approval_list(.:format)                     api/agreements#approval_list
#                       api_client_list GET    /api/agreements/client_list(.:format)                       api/agreements#client_list
#                      api_project_list GET    /api/agreements/project_list(.:format)                      api/agreements#project_list
#             api_expense_approval_list GET    /api/agreements/expense_approval_list(.:format)             api/agreements#expense_approval_list
#
# Routes for Teaspoon::Engine:
#    root GET  /                             teaspoon/suite#index
# fixture GET  /fixtures/*filename(.:format) teaspoon/suite#fixtures
#   suite GET  /:suite(.:format)             teaspoon/suite#show {:suite=>"default"}
#         POST /:suite/:hook(.:format)       teaspoon/suite#hook {:suite=>"default", :hook=>"default"}
#
# Routes for LetterOpenerWeb::Engine:
# clear_letters DELETE /clear(.:format)                 letter_opener_web/letters#clear
# delete_letter DELETE /:id(.:format)                   letter_opener_web/letters#destroy
#       letters GET    /                                letter_opener_web/letters#index
#        letter GET    /:id(/:style)(.:format)          letter_opener_web/letters#show
#               GET    /:id/attachments/:file(.:format) letter_opener_web/letters#attachment

Rails.application.routes.draw do
  resources :approval_groups
  root 'pages#home'

  get 'home', to: 'pages#home'
  post 'hooks', to: "hooks#create"

  resources :user_sessions
  resources :password_settings

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
    get 'csv',  to: 'projects/csv#download', defaults: { format: :csv }, as: 'project_download_csv'
  end
  scope path: 'projects/:project_id' do
    get 'show', to: 'pages#project_show', as: 'project_show'
  end
  scope path: 'approvals' do
    get 'new', to: 'pages#approval_new', as: 'approval_new'
    get 'list', to: 'pages#approval_list', as: 'approval_list'
  end
  scope path: 'approvals/:approval_id' do
    get 'show', to: 'pages#approval_show', as: 'approval_show'
    get 'edit', to: 'pages#approval_edit', as: 'approval_edit'
  end
  scope path: 'expense' do
    get 'new', to: 'pages#expense_new', as: 'expense_new'
    get 'list', to: 'pages#expense_list', as: 'expense_list'
    get 'pdf', to: 'expenses/pdf#download', as: 'expense_download'
    get 'csv', to: 'pages#expense_csv', as: 'expense_csv'
    post 'tocsv', to: 'expenses/csv#download_csv', as: 'expense_download_csv'
  end
  scope path: 'expense/:expense_id' do
    get 'edit', to: 'pages#expense_edit', as: 'expense_edit'
    get 'pdf', to: 'expenses/pdf#download', as: 'expense_download_pdf'
  end
  scope path: 'expense/approval' do
    get 'new', to: 'pages#expense_approval_new', as: 'expense_approval_new'
    get 'list', to: 'pages#expense_approval_list', as: 'expense_approval_list'
  end
  scope path: 'expense/approval/:expense_approval_id' do
    get 'show', to: 'pages#expense_approval_show', as: 'expense_approval_show'
    get 'edit', to: 'pages#expense_approval_edit', as: 'expense_approval_edit'
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
  scope path: 'agreements' do
    get 'list', to: 'pages#agreement_list', as: 'agreement_list'
  end

  namespace :admin do
    get 'users', to: 'pages#users'
    get 'fb_date_output', to: 'pages#fb_date_output'
    post 'fb_download_csv', to: 'fb#fb_download_csv', as: 'fb_download_csv'
    scope path: 'users/:user_id' do
      get 'show', to: 'pages#user_show', as: 'user_show'
    end
  end

  # letter opener
  mount LetterOpenerWeb::Engine, at: 'letter_opener' if Rails.env.development?
end
