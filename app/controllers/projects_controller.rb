class ProjectsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @user.punch(request)
    @projects = @user.projects.paginate(page: params[:page], per_page: 21)
  end

  def show
    @project = Project.find(params[:id])
    @vendor = @project.user
    @vendor.punch(request)
    @projects = @vendor.projects
  end
end
