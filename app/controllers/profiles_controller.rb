class ProfilesController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @user.punch(request)
    @projects = @user.projects
  end

  def update_download_catalog_count
    @user = User.find(params[:user_id])
    @user.profile.update(catalog_download_count: @user.profile.catalog_download_count+1)
  end

end
