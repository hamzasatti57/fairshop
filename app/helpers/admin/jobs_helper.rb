module Admin::JobsHelper
  def job_form_attributes job
    if Job.exists? job.id
      return { url: admin_job_path(job), method: :put }
    else
      return { url: admin_jobs_path, method: :post }
    end
  end
end
