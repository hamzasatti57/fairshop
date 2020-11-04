class BillingAddressesController < ApplicationController
  before_action :get_billing_address, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  def new
    @billing_address = BillingAddress.new
  end

  def create
    results = Geocoder.search(params["billing_address"]["address"])
    # params["billing_address"]["country_id"] = Country.find_or_create_by(title: results.first.country).id
    params["billing_address"]["province_id"] = Province.find_or_create_by(title: results.first.state).id
    params["billing_address"]["city_id"] = City.find_or_create_by(title: results.first.city, province_id: params["billing_address"]["province_id"]).id
    params["billing_address"]["latitude"] = results.first.coordinates[0]
    params["billing_address"]["longitude"] = results.first.coordinates[1]
    params["billing_address"]["postal_code"] = Geocoder.search(results.first.coordinates).first.postal_code.to_s
    @billing_address = BillingAddress.where(is_primary: true, user_id: current_user.id).last if BillingAddress.where(is_primary: true, user_id: current_user.id).present?
    if @billing_address.blank? || params["billing_address"]["is_primary"] == "false"
      @shipping_address = BillingAddress.where(is_primary: false, user_id: current_user.id).last if BillingAddress.where(is_primary: false, user_id: current_user.id).present?
      if @shipping_address.present?
        params["billing_address"]["instruction"] = @billing_address.instruction if @billing_address.present?
        @shipping_address.update!(billing_address_params)
        @billing_address = @shipping_address
      else
        @billing_address = current_user.billing_addresses.create!(billing_address_params)
      end
    else
      params["billing_address"]["instruction"] = @billing_address.instruction if @billing_address.present?
      current_user.update!(user_params)
      @billing_address.update!(billing_address_params)
    end
    @product_ids = Product.where(id: current_user.user_carts.where(status: 0).last.user_cart_products.pluck(:product_id)).pluck(:product_category_id)
    @category_ids = ProductCategory.where(id: @product_ids).pluck(:category_id) if @product_ids.present?
    @shipping_price = Category.where(id: @category_ids).pluck(:shipping_price).compact.max.to_i
    @checkout = Checkout.create!(billing_address_id: @billing_address.id, user_id: current_user.id, user_cart_id: current_user.user_carts.where(status: 0).last.present? ? current_user.user_carts.where(status: 0).last.id : nil, amount: (current_user.user_carts.where(status: 0).present? && current_user.user_carts.where(status: 0).last.user_cart_products.present?) ? current_user.user_carts.where(status: 0).last.user_cart_products.pluck(:sub_total).sum.to_i + @shipping_price.to_i : 0)
  end

  def save_address
    results = Geocoder.search(params["billing_address"]["address"])
    # params["billing_address"]["country_id"] = Country.find_or_create_by(title: results.first.country).id
    params["billing_address"]["province_id"] = Province.find_or_create_by(title: results.first.state).id
    params["billing_address"]["city_id"] = City.find_or_create_by(title: results.first.city, province_id: params["billing_address"]["province_id"]).id
    params["billing_address"]["latitude"] = results.first.coordinates[0]
    params["billing_address"]["longitude"] = results.first.coordinates[1]
    params["billing_address"]["postal_code"] = Geocoder.search(results.first.coordinates).first.postal_code.to_s
    @billing_address = BillingAddress.where(is_primary: true, user_id: current_user.id).last if BillingAddress.where(is_primary: true, user_id: current_user.id).present?
    if @billing_address.present?
      @billing_address.update!(billing_address_params)
    else
      params["billing_address"]["is_primary"] = true
      current_user.billing_addresses.create!(billing_address_params)
    end
    render :json => @billing_address
    
  end

  private

  def billing_address_params
    params.required(:billing_address).permit(:address, :postal_code, :user_id, :city_id, :province_id, :country_id, :is_primary, :instruction, :latitude, :longitude, :landmark, :street, :unit_no, :house_no, :suburb, :complex, :secondary_number)
  end

  def user_params
    params.required(:user).permit(:first_name, :last_name, :contact_details, :email)
  end

  def get_billing_address
    @billing_address = billing_address.find(params[:id])
  end
end
