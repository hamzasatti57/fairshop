require 'net/https'
require 'uri'
require 'json'

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
    @shipping_address = current_user.billing_addresses.where(is_primary: false).last if current_user.billing_addresses.present?
    @cart = current_user.user_carts.where(status: 0).last.user_cart_products if current_user.user_carts.where(status: 0).present?
    @sum = current_user.user_carts.where(status: 0).last.user_cart_products.pluck(:sub_total).sum if current_user.user_carts.where(status: 0).present? && current_user.user_carts.where(status: 0).last.user_cart_products.present?
    @product_ids = Product.where(id: current_user.user_carts.where(status: 0).last.user_cart_products.pluck(:product_id)).pluck(:product_category_id) if Product.where(id: current_user.user_carts.where(status: 0).last.present?
    @category_ids = ProductCategory.where(id: @product_ids).pluck(:category_id) if @product_ids.present?
    @delivery_fee = ProductCategory.where(id: @product_ids).pluck(:delivery_fee).compact.max.to_i if ProductCategory.where(id: @product_ids).pluck(:delivery_fee).present?
    @shipping_price = @sum.to_i < 5000 ? @delivery_fee : 0
  end

  def notify
    # Parameters: {"m_payment_id"=>"", "pf_payment_id"=>"1115681", "payment_status"=>"COMPLETE", "item_name"=>"Sample Product", "item_description"=>"", "amount_gross"=>"4600.00", "amount_fee"=>"-105.80", "amount_net"=>"4494.20", "custom_str1"=>"", "custom_str2"=>"", "custom_str3"=>"", "custom_str4"=>"", "custom_str5"=>"", "custom_int1"=>"", "custom_int2"=>"", "custom_int3"=>"", "custom_int4"=>"", "custom_int5"=>"", "name_first"=>"HamzaSatti", "name_last"=>"", "email_address"=>"hamza@gmail.com", "merchant_id"=>"10019032", "signature"=>"fa590d44ff9c8f2a4774a7d60c7ad3fb"}
    @user = User.find_by_email(params["email_address"])
    random_number = rand(6**6)
    @user.user_carts.last.update(status: 2, otp_code: random_number.to_s)
    UserPayment.create!(user_id: @user.present? ? @user.id : current_user.id, amount: params["amount_gross"])
    xml = File.open(Rails.root.join('public', 'Sales.xml'))
    data = Hash.from_xml(xml)
    logger.info "=========#{data}=========="
    _file_name = "Sale_Invoice_#{Time.now.strftime("%Y_%d_%m_%H_%M").to_s}"
    data["Transaction"]["SalesHeader"]["CustomerName"] = params["name_first"] + " " + params["name_last"]
    data["Transaction"]["SalesHeader"]["TotalSalePriceAfterDiscount"] = params["amount_gross"]
    data["Transaction"]["SalesHeader"]["CustomerPin"] = random_number.to_s
    data["Transaction"]["SalesHeader"]["DateOfSale"] = Time.now.to_s
    sale_detail = {"StockItemId"=>"14CB7ADA-295E-43FD-AECD-243106D55445", "Quantity"=>"1", "UnitSellingPrice"=>"999.9900", "DiscountPerUnit"=>"0.0000", "UnitPriceAfterDiscount"=>"999.9900", "TotalPriceAfterDiscount"=>"999.9900", "UnitVAT"=>"130.4335"}
    data["Transaction"]["Details"]["SalesDetails"] = []
    detail_array = @user.user_carts.last.user_cart_products.each do |product|
      sale_detail["Quantity"] = product.quantity.to_s
      sale_detail["UnitSellingPrice"] = product.product.price.to_s
      sale_detail["StockItemID"] = product.product.stock_item_id.present? ? product.product.stock_item_id.to_s : ""
      sale_detail["TotalPriceAfterDiscount"] = product.product.price.to_s
      sale_detail["UnitVAT"] = (product.product.price.to_i * 15).to_s
    end
    data["Transaction"]["Details"]["SalesDetails"] << detail_array.map(&:attributes)
    data["Transaction"]["Details"]["SalesDetails"] = data["Transaction"]["Details"]["SalesDetails"].flatten
    data["Transaction"]["DeliveryDetails"]["Province"] = @user.user_carts.last.checkout.billing_address.province.title
    data["Transaction"]["DeliveryDetails"]["City"] = @user.user_carts.last.checkout.billing_address.city.title
    data["Transaction"]["DeliveryDetails"]["Address"] = @user.user_carts.last.checkout.billing_address.address
    data["Transaction"]["DeliveryDetails"]["PostalCode"] = @user.user_carts.last.checkout.billing_address.postal_code
    logger.info "=========#{data.to_xml}=========="
    FileUtils.rm_rf(Rails.root.join('public/Sales/', "#{_file_name}.xml"))
    File.open("#{Rails.root}/public/Sales/#{_file_name}.xml", "w") << data.to_xml
  end

  def peach_payment
    @checkout_id = current_user.peach_payments.last.checkout_id
  end

  def peach_payment_request
    @sum = current_user.user_carts.where(status: 0).last.user_cart_products.pluck(:sub_total).sum if current_user.user_carts.where(status: 0).present? && current_user.user_carts.where(status: 0).last.user_cart_products.present?
    @product_ids = Product.where(id: current_user.user_carts.where(status: 0).last.user_cart_products.pluck(:product_id)).pluck(:product_category_id)
    @category_ids = ProductCategory.where(id: @product_ids).pluck(:category_id) if @product_ids.present?
    @delivery_fee = ProductCategory.where(id: @product_ids).pluck(:delivery_fee).compact.max.to_i if @product_ids.present? && ProductCategory.where(id: @product_ids).pluck(:delivery_fee).present?
    @shipping_price = @sum.to_i < 5000 ? @delivery_fee : 0
    @sum = @sum.to_i + @shipping_price.to_i
    logger.info "===========#{@sum.to_i.round(2)}==========="
    results = `/usr/bin/curl https://test.oppwa.com/v1/checkouts \
     -d "entityId=8ac7a4ca73d8ca300173e1d5306c1005" \
     -d "amount=#{@sum.to_i.round(2)}" \
     -d "currency=ZAR" \
     -d "paymentType=DB" \
     -H "Authorization: Bearer OGFjN2E0Y2E3M2Q4Y2EzMDAxNzNlMWQ1MWYxZDBmZmV8UHM0RUhKZ0NZdA=="`
     logger.info "=========#{results}============"
    result = JSON.parse(results)
    PeachPayment.create(user_id: current_user.id, checkout_id: result["id"])
    redirect_to peach_payment_path
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
