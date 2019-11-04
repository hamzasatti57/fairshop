class UserMailer < ApplicationMailer

  def job_email(params)

    attachments[params[:attachment].original_filename] = params[:attachment].read()
    mail({
             from: params[:to_email],
             to: params[:from_email],

             subject: "Job Application"
         })

  end
end
