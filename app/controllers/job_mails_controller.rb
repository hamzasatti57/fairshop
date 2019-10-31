class JobMailsController < ApplicationController

  def job_email_send
     UserMailer.job_email(params).deliver
  end
end
