class UserMailer < ApplicationMailer

  def order_confiramtion_email(user)
    @user = user
    mail(to: @user.email, subject: "Thank you for shopping here")
  end

end
