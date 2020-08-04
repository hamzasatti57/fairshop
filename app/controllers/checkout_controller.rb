class CheckoutController < ApplicationController
  before_action :get_checkout, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  def new
    @checkout = Checkout.new
  end

  def create
    @checkout = Checkout.new(checkout_params)
    @billing_address = BillingAddress.where(user_id: current_user.id).last if BillingAddress.where(user_id: current_user.id).present?
    # @billing_address = BillingAddress.last if BillingAddress.count > 0
    @checkout.billing_address_id = @billing_address.id if params["/checkout/new"]["billing_address_id"] == "" && @billing_address.present?
    respond_to do |format|
      if @checkout.save!
        format.json { render @checkout, status: :created}
      else
        format.json { render json: @checkout.errors, status: :unprocessable_entity }
      end
    end
  end

  def index
    @billing_address = current_user.billing_addresses.where(is_primary: true).last if current_user.billing_addresses.present?
    @cart = current_user.user_carts.where(status: 0).last.user_cart_products if current_user.user_carts.where(status: 0).present?
    @sum = current_user.user_carts.where(status: 0).last.user_cart_products.pluck(:sub_total).sum if current_user.user_carts.where(status: 0).present? && current_user.user_carts.where(status: 0).last.user_cart_products.present?
  end

  def notify
    # Parameters: {"m_payment_id"=>"", "pf_payment_id"=>"1115681", "payment_status"=>"COMPLETE", "item_name"=>"Sample Product", "item_description"=>"", "amount_gross"=>"4600.00", "amount_fee"=>"-105.80", "amount_net"=>"4494.20", "custom_str1"=>"", "custom_str2"=>"", "custom_str3"=>"", "custom_str4"=>"", "custom_str5"=>"", "custom_int1"=>"", "custom_int2"=>"", "custom_int3"=>"", "custom_int4"=>"", "custom_int5"=>"", "name_first"=>"HamzaSatti", "name_last"=>"", "email_address"=>"hamza@gmail.com", "merchant_id"=>"10019032", "signature"=>"fa590d44ff9c8f2a4774a7d60c7ad3fb"}
    @user = User.find_by_email(params["email_address"])
    @user.user_carts.last.update(status: 2)
    UserPayment.create!(user_id: @user.present? ? @user.id : current_user.id, amount: params["amount_gross"])
  end

  def cancel_payment
    current_user.checkouts.last.destroy 
  end

  private

  def checkout_params
    params.required("/checkout/new").permit(:billing_address_id, :user_cart_id, :user_id, :amount)
  end

  def get_checkout
    @checkout = checkout.find(params[:id])
  end

end
