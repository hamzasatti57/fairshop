class CheckoutController < ApplicationController
  before_action :get_checkout, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  def new
    @checkout = Checkout.new
  end

  def create
    @checkout = Checkout.new(checkout_params)
    @checkout.billing_address_id = current_user.billing_addresses.last.id if params["/checkout/new"]["billing_address_id"] == ""
    respond_to do |format|
      if @checkout.save
        format.json { render @checkout, status: :created}
      else
        format.json { render json: @checkout.errors, status: :unprocessable_entity }
      end
    end
  end

  def index
    @cart = current_user.user_cart_products
    @sum = current_user.user_cart_products.pluck(:sub_total).sum
  end

  private

  def checkout_params
    params.required("/checkout/new").permit(:billing_address_id, :user_cart_id, :user_id, :amount)
  end

  def get_checkout
    @checkout = checkout.find(params[:id])
  end

end
