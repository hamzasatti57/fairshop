require 'aws-sdk-s3' 

class ConfirmationController < ApplicationController
  before_action :generate_xml

  def index
    # sleep 1
    # @checkout = Checkout.where(user_id: current_user.id).last if Checkout.where(user_id: current_user.id).present?
    @checkout = Checkout.last if Checkout.count > 0
    @billing_address = current_user.billing_addresses.where(is_primary: true).last
    @cart = current_user.user_carts.last.user_cart_products if current_user.user_carts.present?
    @sum = current_user.user_carts.last.user_cart_products.pluck(:sub_total).sum if current_user.user_carts.present? && current_user.user_carts.last.user_cart_products.present?
    UserMailer.order_confiramtion_email(current_user, @checkout, @billing_address, @cart, @sum).deliver
  end

  def generate_xml
    if PeachPayment.last.checkout_id == params["id"]
      random_number = rand(6**6)
      @sum = current_user.user_carts.last.user_cart_products.pluck(:sub_total).sum if current_user.user_carts.present? && current_user.user_carts.last.user_cart_products.present?
      current_user.user_carts.last.update!(status: 2, otp_code: random_number.to_s)
      UserPayment.create!(user_id: current_user.present? ? current_user.id : current_user.id, amount: @sum)
      xml = File.open(Rails.root.join('public', 'Sales.xml'))
      data = Hash.from_xml(xml)
      logger.info "=========#{data}=========="
      _file_name = "Sale_Invoice_#{Time.now.strftime("%Y_%d_%m_%H_%M").to_s}"
      data["Transaction"]["SalesHeader"]["InvoiceNumber"] = (current_user.user_carts.last.id + 1000).to_s
      data["Transaction"]["SalesHeader"]["DeliveryCharge"] = (@sum.to_i * 0.10).to_s
      data["Transaction"]["SalesHeader"]["CustomerName"] = current_user.first_name + " " + current_user.last_name
      data["Transaction"]["SalesHeader"]["TotalSalePriceAfterDiscount"] = @sum.to_s
      data["Transaction"]["SalesHeader"]["CustomerPin"] = random_number.to_s
      data["Transaction"]["SalesHeader"]["DateOfSale"] = Time.now.to_s
      data["Transaction"]["SalesHeader"]["TotalVAT"] = (@sum.to_i * 0.15).to_s
      data["Transaction"]["Details"]["SalesDetails"] = []
      sale_details = {"StockItemId"=>"14CB7ADA-295E-43FD-AECD-243106D55445", "Quantity"=>"1", "UnitSellingPrice"=>"999.9900", "DiscountPerUnit"=>"0.0000", "UnitPriceAfterDiscount"=>"999.9900", "TotalPriceAfterDiscount"=>"999.9900", "UnitVAT"=>"130.4335"}
      current_user.user_carts.last.user_cart_products.each_with_index do |product, index|
        sale = []
        sale[index] = {}
        sale[index]["Quantity"] = product.quantity.to_s
        sale[index]["UnitSellingPrice"] = product.product.price.to_s
        sale[index]["StockItemId"] = product.product.stock_item_id.to_s
        sale[index]["DiscountPerUnit"] = "0.0".to_s
        sale[index]["UnitPriceAfterDiscount"] = product.product.price.to_s
        sale[index]["TotalPriceAfterDiscount"] = product.product.price.to_s
        sale[index]["UnitVAT"] = (product.product.price.to_i * 0.15).to_s
        data["Transaction"]["Details"]["SalesDetails"] << sale[index]
      end
      # data["Transaction"]["Details"]["SalesDetails"] = data["Transaction"]["Details"]["SalesDetails"].flatten
      data["Transaction"]["DeliveryDetails"]["Province"] = current_user.user_carts.last.checkout.billing_address.province.title if current_user.user_carts.last.checkout.present? && current_user.user_carts.last.checkout.billing_address.province.present?
      data["Transaction"]["DeliveryDetails"]["City"] = current_user.user_carts.last.checkout.billing_address.city.title if current_user.user_carts.last.checkout.present? && current_user.user_carts.last.checkout.billing_address.city.present?
      data["Transaction"]["DeliveryDetails"]["Address"] = current_user.user_carts.last.checkout.billing_address.address if current_user.user_carts.last.checkout.present?
      data["Transaction"]["DeliveryDetails"]["PostalCode"] = current_user.user_carts.last.checkout.billing_address.postal_code if current_user.user_carts.last.checkout.present?
      data["Transaction"]["DeliveryDetails"]["CustomerName"] = current_user.first_name + " " + current_user.last_name
      data["Transaction"]["DeliveryDetails"]["DeliveryPrice"] = (@sum.to_i * 0.10).to_s
      data["Transaction"]["DeliveryDetails"]["Instructions"] = current_user.user_carts.last.checkout.billing_address.instruction if current_user.user_carts.last.checkout.present?
      data["Transaction"]["DeliveryDetails"]["Latitude"] = current_user.user_carts.last.checkout.billing_address.latitude if current_user.user_carts.last.checkout.present?
      data["Transaction"]["DeliveryDetails"]["Longitude"] = current_user.user_carts.last.checkout.billing_address.longitude if current_user.user_carts.last.checkout.present?
      data["Transaction"]["DeliveryDetails"]["PhoneNo"] = current_user.contact_details.to_s
      data["Transaction"]["DeliveryDetails"]["DeliveryDate"] = (current_user.user_carts.last.checkout.created_at + 7.days).to_s if current_user.user_carts.last.checkout.present?
      # data["Transaction"]["SalesHeader"]["UnitNo"] = (current_user.user_carts.last.id + 1000).to_s
      data["Transaction"]["Details"] = data["Transaction"]["Details"]["SalesDetails"]
      data = data.to_xml.to_s.gsub("Detail>", "SalesDetails>").gsub(" type=\"array\"", "").gsub("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<hash>\n  ", "").gsub("\n</hash>\n", "").to_yaml.gsub("--- |-\n", '')
      logger.info "=========#{data}=========="
      FileUtils.rm_rf(Rails.root.join('/public/Sales/', "#{_file_name}.xml"))
      File.open("#{Rails.root}/public/Sales/#{_file_name}.xml", "w+b") << data
      s3 = Aws::S3::Resource.new(
        :region => 'us-east-1',
        :access_key_id => 'AKIAJ4TWUFPR24VBAEYA',
        :secret_access_key => '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')
      file = "#{Rails.root}/public/Sales/#{_file_name}.xml"
      logger.info "=========#{file}=========="
      bucket = 'fairprice'
      # Get just the file name
      name = File.basename(file)
      path = 'Sales/' + name
      logger.info "=========#{path}=========="
      object = s3.bucket(bucket).object(path)
      object.put(acl: "public-read", bucket: bucket, body: data, content_type: 'application/xml')

    end
  end
end
