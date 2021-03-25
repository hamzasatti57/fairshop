class JobsController < ApplicationController
  def index
    @jobs = Job.all.paginate(page: params[:page], per_page: 20)
  end
  def show
    @job = Job.find(params[:id])
    @job_next = @job.next
    @job_prev = @job.prev
  end
end
