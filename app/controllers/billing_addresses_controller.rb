class BillingAddressesController < ApplicationController
  before_action :get_billing_address, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  def new
    @billing_address = BillingAddress.new
  end

  def create
    @billing_address = BillingAddress.create!(billing_address_params)
  end

  private

  def billing_address_params
    params.required(:billing_address).permit(:address, :postal_code, :user_id, :city_id, :province_id, :country_id, :is_primary)
  end

  def get_billing_address
    @billing_address = billing_address.find(params[:id])
  end
end
