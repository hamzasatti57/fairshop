class ConfirmationController < ApplicationController
  def index
    @checkout = current_user.checkouts.last
    @cart = current_user.user_cart_products
    @sum = current_user.user_cart_products.pluck(:sub_total).sum
  end
end
