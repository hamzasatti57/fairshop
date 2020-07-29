class CheckoutController < ApplicationController
  before_action :get_checkout, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  def new
    @checkout = Checkout.new
  end

  def create
    @checkout = Checkout.create(checkout_params)
  end

  def index
    @cart = current_user.user_cart_products
    @sum = current_user.user_cart_products.pluck(:sub_total).sum
  end

  private

  def checkout_params
    params.required(:checkout).permit(:billing_address_id, :user_cart_product_id, :user_id)
  end

  def get_checkout
    @checkout = checkout.find(params[:id])
  end

end
