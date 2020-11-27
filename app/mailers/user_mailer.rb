class UserMailer < ApplicationMailer
  default from: 'onlineorders@fairprice.co.za'

  def order_confiramtion_email(user, checkout, billing_address, cart, sum, shipping_price)
    @user = user
    @checkout = checkout
    @billing_address = billing_address
    @cart = cart
    @sum = sum
    @shipping_price = shipping_price
    mail(to: @user.email, subject: "Thank you for shopping here")
  end

end
