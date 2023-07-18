class TaskMailer < ApplicationMailer
  default from: 'collegevibes.epizy@gmail.com'
  def create
    @task = params[:task]
    @assign_user = params[:assign_user]
    @dashboard_mytask_path = params[:redirect]
    mail(to: params[:to], subject: 'Assignment of Task')
  end
end
