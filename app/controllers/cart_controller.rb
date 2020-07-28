class CartController < ApplicationController
  def index
    @cart = current_user.user_cart_products
    @sum = current_user.user_cart_products.pluck(:sub_total).sum
  end

  
end
