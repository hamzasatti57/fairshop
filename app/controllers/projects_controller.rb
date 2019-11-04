class ProjectsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @user.punch(request)
    @projects = @user.projects.paginate(page: params[:page], per_page: 21)
  end

  def show
    @project = Project.find(params[:id])
    @project.punch(request)
    @vendor = @project.user
    @vendor.punch(request)
    @projects = @vendor.projects
    @likes = @project.likes
    @comments = @project.comments.order("created_at DESC")
    @avg_rating = @project.ratings.average(:value)
    if user_signed_in?
      if current_user.customer_ratings.where(parent_id: @project.id, parent_type: Rating.parent_type_project).any?
        @rating = current_user.customer_ratings.where(parent_id: @project.id, parent_type: 1).first
      end
    end
  end
end
