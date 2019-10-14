class Admin::ProjectsController < AdminController

  before_action :load_projects, only: :index
  before_action :load_user_project, only: [:new, :create]
  load_and_authorize_resource
  def index
    # @projects = current_user.projects
    # authorize! :index, @projects
  end

  def new
    # @project = current_user.projects.new
  end

  def create
    @project = current_user.projects.new(project_params.merge(company_id: current_user.companies.first.id))
    if @project.save
      # @project.images.attach(params[:project][:images])
      flash[:success] = "Project successfully created"
      render 'show'
    else
      render 'new'
    end
  end
  def edit

  end
  def update
    if @project.update(project_params)
      flash[:success] = "Project successfully Updated"
      render 'show'
    else
      render 'edit'
    end
  end
  def show

  end
  def destroy

    @project.destroy
    flash[:danger] = "Project Deleted"
    redirect_to admin_projects_path
  end

  def delete_image_attachment
    project = Project.find(params[:id])
    @image = ActiveStorage::Blob.find_signed(params[:image_id])
    @image.attachments.destroy_all

    respond_to do |format|
      format.html { redirect_to edit_admin_project_path(project)}
      format.json { head :no_content }
      format.js
    end

  end

  private

    def load_user_project
      if action_name == 'new'
        @project = Project.new
      elsif action_name == 'create'
        @project = Project.new(project_params)
      end
      # @project = Project.new
    end

    def load_projects
      @projects = Project.accessible_by(current_ability)
    end

    def project_params
      params.required(:project).permit(:title, :description, :company_id, images: [])
    end
    def get_project
      @project = Project.find(params[:id])
    end
end
