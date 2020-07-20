class CartController < ApplicationController
  def index
    @cart = current_user.user_cart_products
  end

  
end
