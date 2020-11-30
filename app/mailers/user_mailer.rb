class UserMailer < ApplicationMailer
  include Devise::Controllers::UrlHelpers
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

  def welcome_reset_password_instructions(user)
    @user = user
    mail(to: user.email, subject: 'Password Reset Link')
  end
end
