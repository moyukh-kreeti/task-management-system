Rails.application.routes.draw do
  get 'tasks/index'
  get 'assign_task/addTask'
  get 'admin/index'
  root 'dashboard#index'
  get 'authentication/login', to: 'authentication#login'
  get '/auth/:provider/callback', to: 'authentication#create'

  get 'authentication/logout', to: 'authentication#logout'

  # resources :users do 

  #   member do
  #     get 'profile/index'
  #     post 'uploadimage'
  #   end
  # end

  get 'profile/index'

  post 'profile/uploadimage'
  
  get 'dashboard/mytask' 

  get 'dashboard/assigntask'

  get 'dashboard/adminpanel'

  post 'admin/addUser'

  post 'admin/makeAdmin'

  post 'admin/makeHr'

  post 'admin/addTaskCategories'

  delete 'admin/removeTaskCategories'


  scope '/dashboard/assigntask' do
    resources :tasks
  end

  post 'tasks/change_task_status'
  
  

end
