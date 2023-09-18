# frozen_string_literal: true

# rubocop:disable all
Rails.application.routes.draw do
  root 'dashboard#index'
  get 'superuser/add/adminuser', to: 'authentication#add_admin_user'
  post 'superuser/add/adminuser', to: 'authentication#add_user'
  get 'authentication/login', to: 'authentication#login'
  get '/auth/:provider/callback', to: 'authentication#create'
  get 'authentication/logout', to: 'authentication#logout'
  
  # Profile routes
  get 'profile/index'
  post 'profile/uploadimage'

  # Dashboard routes
  get 'dashboard/mytask'
  get 'dashboard/assigntask'
  get 'dashboard/adminpanel'
  get 'dashboard/hrpanel'
  put 'dashboard/mark_all_read'
  scope '/dashboard/hrpanel' do
    get 'generate_pdf', to: 'pdfs#generate_pdf'
  end
  scope '/dashboard/assigntask' do
    resources :tasks
    patch 'approve_task', to: 'tasks#approve'
  end

  # Admin Panel routes
  resources :admin, only: [] do
    collection do
      post 'add_user'
      post 'make_admin'
      post 'make_hr'
      post 'add_task_categories'
      patch 'update_task_categories'
      delete 'remove_task_categories'
      patch 'send_to_hr'
      get 'search_user'
    end
  end

  # Task routes
  post 'tasks/change_task_status'
  post 'tasks/change_subtask_status'
  get 'tasks/apply_filters'
  post 'tasks/add_attachments'
  delete 'tasks/delete_attachments'
  get 'tasks/show'
  get 'tasks/search'
  
  # Exceptions
  match '*unmatched', to: 'application#not_found', layout: false, via: :all, constraints: lambda { |req|
    req.path.exclude? 'rails/active_storage'
  }
end
# rubocop:enable all
