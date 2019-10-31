class Admin::JobsController < AdminController
  before_action :get_job, only: [:show, :edit, :update, :destroy]

  def index
    @jobs = current_user.jobs
  end

  def new
    @job = Job.new
  end

  def create
    @job = Job.new(job_params.merge(user_id: current_user.id))
    if @job.save
      flash[:success] = "Job Successfully Created"
      redirect_to admin_jobs_path
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    if @job.update(job_params)
      flash[:success] = "Job Succesfully Updated"
      redirect_to admin_jobs_path
    else
      render 'edit'
    end
  end

  def destroy
    @job = Job.find(params[:id])
    @job.destroy
    flash[:danger] = "Job Successfully Deleted"
    redirect_to admin_jobs_path
  end

  private

  def job_params
    params.required(:job).permit(:company, :title, :description, :position, :address, :country, :salary, :user_id, :image)
  end

  def get_job
    @job = Job.find(params[:id])
  end
end
