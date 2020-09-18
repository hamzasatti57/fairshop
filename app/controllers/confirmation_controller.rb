require 'aws-sdk-s3' 

class ConfirmationController < ApplicationController
  before_action :generate_xml

  def index
    # sleep 1
    # @checkout = Checkout.where(user_id: current_user.id).last if Checkout.where(user_id: current_user.id).present?
    @checkout = Checkout.last if Checkout.count > 0
    @cart = current_user.user_carts.last.user_cart_products if current_user.user_carts.present?
    @sum = current_user.user_carts.last.user_cart_products.pluck(:sub_total).sum if current_user.user_carts.present? && current_user.user_carts.last.user_cart_products.present?
  end

  def generate_xml
    if PeachPayment.last.checkout_id == params["id"]
      random_number = rand(6**6)
      @sum = current_user.user_carts.last.user_cart_products.pluck(:sub_total).sum if current_user.user_carts.present? && current_user.user_carts.last.user_cart_products.present?
      current_user.user_carts.last.update(status: 2, otp_code: random_number.to_s)
      UserPayment.create!(user_id: current_user.present? ? current_user.id : current_user.id, amount: @sum)
      xml = File.open(Rails.root.join('public', 'Sales.xml'))
      data = Hash.from_xml(xml)
      logger.info "=========#{data}=========="
      _file_name = "Sale_Invoice_#{Time.now.strftime("%Y_%d_%m_%H_%M").to_s}"
      data["Transaction"]["SalesHeader"]["CustomerName"] = current_user.first_name + " " + current_user.last_name
      data["Transaction"]["SalesHeader"]["TotalSalePriceAfterDiscount"] = @sum.to_s
      data["Transaction"]["SalesHeader"]["OtpCode"] = random_number.to_s
      data["Transaction"]["SalesHeader"]["DateOfSale"] = Time.now.to_s
      data["Transaction"]["Details"]["SalesDetails"] = []
      sale_details = {"StockItemId"=>"14CB7ADA-295E-43FD-AECD-243106D55445", "Quantity"=>"1", "UnitSellingPrice"=>"999.9900", "DiscountPerUnit"=>"0.0000", "UnitPriceAfterDiscount"=>"999.9900", "TotalPriceAfterDiscount"=>"999.9900", "UnitVAT"=>"130.4335"}
      current_user.user_carts.last.user_cart_products.each do |product|
        sale_details["Quantity"] = product.quantity.to_s
        sale_details["UnitSellingPrice"] = product.product.price.to_s
        sale_details["StockItemID"] = product.product.stock_item_id.to_s
        sale_details["TotalPriceAfterDiscount"] = product.product.price.to_s
        sale_details["UnitPriceAfterDiscount"] = product.product.price.to_s
        sale_details["UnitVAT"] = (product.product.price.to_i * 0.15).to_s
        data["Transaction"]["Details"]["SalesDetails"] << sale_details
      end
      # data["Transaction"]["Details"]["SalesDetails"] = data["Transaction"]["Details"]["SalesDetails"].flatten
      data["Transaction"]["DeliveryDetails"]["Province"] = current_user.user_carts.last.checkout.billing_address.province.title if current_user.user_carts.last.checkout.present?
      data["Transaction"]["DeliveryDetails"]["City"] = current_user.user_carts.last.checkout.billing_address.city.title if current_user.user_carts.last.checkout.present?
      data["Transaction"]["DeliveryDetails"]["Address"] = current_user.user_carts.last.checkout.billing_address.address if current_user.user_carts.last.checkout.present?
      data["Transaction"]["DeliveryDetails"]["PostalCode"] = current_user.user_carts.last.checkout.billing_address.postal_code if current_user.user_carts.last.checkout.present?
      logger.info "=========#{data.to_xml}=========="
      FileUtils.rm_rf(Rails.root.join('/public/Sales/', "#{_file_name}.xml"))
      File.open("#{Rails.root}/public/Sales/#{_file_name}.xml", "w+b") << data.to_xml
      s3 = Aws::S3::Resource.new(
        :region => 'us-east-1',
        :access_key_id => 'AKIAJ4TWUFPR24VBAEYA',
        :secret_access_key => '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')
      file = "/var/www/fair-price/public/Sales/Sale_Invoice_2020_18_09_10_59.xml"
      logger.info "=========#{file}=========="
      bucket = 'fairprice'
      # Get just the file name
      name = File.basename(file)
      path = 'Sales/' + name
      logger.info "=========#{path}=========="
      # Create the object to upload
      # obj = s3.bucket(bucket).object(path)

      # Upload it      
      # obj.upload_file(file, content_type: 'application/xml')
      object = s3.bucket(bucket).object(path)
      File.open(path, 'rb') do |file|
        object.put(acl: "public-read", bucket: bucket, body: file, content_type: 'application/xml')
      end

    end
  end
end
