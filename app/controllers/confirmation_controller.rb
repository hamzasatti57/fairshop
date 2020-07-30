class ConfirmationController < ApplicationController
  def index
    # sleep 1
    # @checkout = Checkout.where(user_id: current_user.id).last if Checkout.where(user_id: current_user.id).present?
    @checkout = Checkout.last if Checkout.count > 0
    @cart = current_user.user_cart_products
    @sum = current_user.user_cart_products.pluck(:sub_total).sum
  end
end
