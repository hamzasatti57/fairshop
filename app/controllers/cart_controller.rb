class CartController < ApplicationController
  def index
    @cart = current_user.user_carts.where(status: 0).last.user_cart_products if current_user.user_carts.where(status: 0).present?
    @sum = current_user.user_carts.where(status: 0).last.user_cart_products.pluck(:sub_total).sum if current_user.user_carts.where(status: 0).present? && current_user.user_carts.where(status: 0).last.user_cart_products.present?
  end

end