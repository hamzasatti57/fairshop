class BillingAddressesController < ApplicationController
  before_action :get_billing_address, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  def new
    @billing_address = BillingAddress.new
  end

  def create
    @billing_address = BillingAddress.where(is_primary: true, user_id: current_user.id).last if BillingAddress.where(is_primary: true, user_id: current_user.id).present?
    if @billing_address.blank? || params["billing_address"]["is_primary"] == "false"
      @billing_address = BillingAddress.create!(billing_address_params)
    else
      @billing_address.update!(billing_address_params)    
    end
    @checkout = Checkout.create!(billing_address_id: @billing_address.id, user_id: current_user.id, user_cart_id: current_user.user_carts.where(status: 0).last.present? ? current_user.user_carts.where(status: 0).last.id : nil, amount: (current_user.user_carts.where(status: 0).present? && current_user.user_carts.where(status: 0).last.user_cart_products.present?) ? current_user.user_carts.where(status: 0).last.user_cart_products.pluck(:sub_total).sum : 0)
  end

  private

  def billing_address_params
    params.required(:billing_address).permit(:address, :postal_code, :user_id, :city_id, :province_id, :country_id, :is_primary)
  end

  def get_billing_address
    @billing_address = billing_address.find(params[:id])
  end
end
