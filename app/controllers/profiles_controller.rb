class ProfilesController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @user.punch(request)
    @projects = @user.projects
  end
end
