Rails.application.routes.draw do
  root 'dashboard#index'
  get 'tasks/index'
  get 'assign_task/addTask'
  get 'admin/index'
  get 'authentication/login', to: 'authentication#login'
  get '/auth/:provider/callback', to: 'authentication#create'
  get 'authentication/logout', to: 'authentication#logout'
  get 'profile/index'
  post 'profile/uploadimage'
  get 'dashboard/mytask'
  get 'dashboard/assigntask'
  get 'dashboard/adminpanel'
  get 'dashboard/hrpanel'
  put 'dashboard/mark_all_read'
  get 'admin/search_user'
  post 'admin/addUser'
  post 'admin/makeAdmin'
  post 'admin/makeHr'
  post 'admin/addTaskCategories'
  patch 'admin/send_to_hr'
  delete 'admin/removeTaskCategories'
  scope '/dashboard/assigntask' do
    resources :tasks
    patch 'approve_task', to: 'tasks#approve'
  end
  post 'tasks/change_task_status'
  post 'tasks/change_subtask_status'
  get 'tasks/apply_filters'
  post 'tasks/add_attachments'
  get 'tasks/show'
  get 'tasks/search'
  scope '/dashboard/hrpanel' do
    get 'generate_pdf', to: 'pdfs#generate_pdf'
  end
end
