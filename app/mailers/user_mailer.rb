class UserMailer < ApplicationMailer
  default from: 'billing@fairprice.co.za'

  def order_confiramtion_email(user, checkout, billing_address, cart, sum)
    @user = user
    @checkout = checkout
    @billing_address = billing_address
    @cart = cart
    @sum = sum
    mail(to: @user.email, subject: "Thank you for shopping here")
  end

end
