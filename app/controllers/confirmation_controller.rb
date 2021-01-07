require 'aws-sdk-s3' 
require 'net/ssh'
require 'net/sftp'

class ConfirmationController < ApplicationController
  before_action :generate_xml

  def index
    # sleep 1
    # @checkout = Checkout.where(user_id: current_user.id).last if Checkout.where(user_id: current_user.id).present?
    @checkout = Checkout.where(user_id: current_user.id).last if Checkout.count > 0
    @billing_address = current_user.billing_addresses.where(is_primary: true).last
    @cart = Checkout.where(user_id: current_user.id).last.user_cart.user_cart_products if Checkout.where(user_id: current_user.id).present?
    @initial_sum = Checkout.where(user_id: current_user.id).last.user_cart.user_cart_products.pluck(:sub_total).sum if current_user.user_carts.present? && Checkout.where(user_id: current_user.id).last.user_cart.user_cart_products.present?
    @product_ids = Product.where(id: Checkout.where(user_id: current_user.id).last.user_cart.user_cart_products.pluck(:product_id)).pluck(:product_category_id)
    @category_ids = ProductCategory.where(id: @product_ids).pluck(:category_id) if @product_ids.present?
    @delivery_fee = ProductCategory.where(id: @product_ids).pluck(:delivery_fee).compact.max.to_i if @product_ids.present? && ProductCategory.where(id: @product_ids).pluck(:delivery_fee).present?
    @shipping_price = @initial_sum.to_i < 5000 ? @delivery_fee : 0
    @sum = @initial_sum.to_i + @shipping_price.to_i
    current_user.user_carts.update_all(status: 2)
    UserMailer.order_confiramtion_email(current_user, @checkout, @billing_address, @cart, @sum, @shipping_price).deliver
  end

  def generate_xml
    if current_user.user_carts.where(status: "pending").blank?
      flash[:info] = "Your order is  already processed."
      return redirect_to root_path
    end
    if PeachPayment.last.checkout_id == params["id"]
      if Checkout.where(user_id: current_user.id).last.present? && Checkout.where(user_id: current_user.id).last.billing_address.province.blank?
        results = Geocoder.search(Checkout.where(user_id: current_user.id).last.billing_address.address)
        province_id = Province.find_or_create_by(title: results.first.state).id
        city_id = City.find_or_create_by(title: results.first.city, province_id: province_id).id
        Checkout.where(user_id: current_user.id).last.billing_address.update(province_id: province_id, city_id: city_id)
      end
      random_number = (SecureRandom.random_number(9e4) + 1e4).to_i
      @initial_sum = Checkout.where(user_id: current_user.id).last.user_cart.user_cart_products.pluck(:sub_total).sum if current_user.user_carts.present? && Checkout.where(user_id: current_user.id).last.user_cart.user_cart_products.present?
      @product_ids = Product.where(id: Checkout.where(user_id: current_user.id).last.user_cart.user_cart_products.pluck(:product_id)).pluck(:product_category_id)
      @category_ids = ProductCategory.where(id: @product_ids).pluck(:category_id) if @product_ids.present?
      @delivery_fee = ProductCategory.where(id: @product_ids).pluck(:delivery_fee).compact.max.to_i if @product_ids.present? && ProductCategory.where(id: @product_ids).pluck(:delivery_fee).present?
      @shipping_price = @initial_sum.to_i < 5000 ? @delivery_fee : 0
      @sum = @initial_sum.to_i + @shipping_price.to_i
      Checkout.where(user_id: current_user.id).last.user_cart.update!(status: 2, otp_code: random_number.to_s, address: Checkout.where(user_id: current_user.id).last.billing_address.address)
      UserPayment.create!(user_id: current_user.present? ? current_user.id : current_user.id, amount: @sum)
      xml = File.open(Rails.root.join('public', 'Sales.xml'))
      data = Hash.from_xml(xml)
      logger.info "=========#{data}=========="
      _file_name = "Sale_Invoice_#{Time.now.strftime("%Y_%d_%m_%H_%M").to_s}"
      data["Transaction"]["SalesHeader"]["InvoiceNumber"] = (Checkout.where(user_id: current_user.id).last.user_cart.id + 1000).to_s
      data["Transaction"]["SalesHeader"]["DeliveryCharge"] = @shipping_price.to_s
      data["Transaction"]["SalesHeader"]["CustomerName"] = current_user.first_name + " " + current_user.last_name
      data["Transaction"]["SalesHeader"]["TotalSalePriceAfterDiscount"] = @sum.to_s
      data["Transaction"]["SalesHeader"]["CustomerPin"] = random_number.to_s
      data["Transaction"]["SalesHeader"]["DateOfSale"] = Time.now.to_s.gsub(" +0000", "")
      data["Transaction"]["SalesHeader"]["TotalVAT"] = (@sum.to_i * 0.15).to_s
      data["Transaction"]["Details"]["SalesDetails"] = []
      sale_details = {"StockItemId"=>"14CB7ADA-295E-43FD-AECD-243106D55445", "StockProfile"=>"White", "Quantity"=>"1", "UnitSellingPrice"=>"999.9900", "DiscountPerUnit"=>"0.0000", "UnitPriceAfterDiscount"=>"999.9900", "TotalPriceAfterDiscount"=>"999.9900", "UnitVAT"=>"130.4335"}
      Checkout.where(user_id: current_user.id).last.user_cart.user_cart_products.each_with_index do |product, index|
        sale = []
        sale[index] = {}
        sale[index]["Quantity"] = product.quantity.to_s
        sale[index]["UnitSellingPrice"] = product.product.price.to_s
        sale[index]["StockItemId"] = product.product.stock_item_id.to_s
        sale[index]["StockProfile"] = product.color.title.to_s if product.color.present?
        sale[index]["DiscountPerUnit"] = "0.0".to_s
        sale[index]["UnitPriceAfterDiscount"] = product.product.price.to_s
        sale[index]["TotalPriceAfterDiscount"] = product.product.price.to_s
        sale[index]["UnitVAT"] = (product.product.price.to_i * 0.15).to_s
        data["Transaction"]["Details"]["SalesDetails"] << sale[index]
      end
      @last_checkout = Checkout.where(user_id: current_user.id).last
      # data["Transaction"]["Details"]["SalesDetails"] = data["Transaction"]["Details"]["SalesDetails"].flatten
      data["Transaction"]["DeliveryDetails"]["Province"] = @last_checkout.billing_address.province.title if @last_checkout.present? && @last_checkout.billing_address.province.present?
      data["Transaction"]["DeliveryDetails"]["City"] = @last_checkout.billing_address.city.title if @last_checkout.present? && @last_checkout.billing_address.city.present?
      data["Transaction"]["DeliveryDetails"]["Address"] = @last_checkout.billing_address.address if @last_checkout.present?
      data["Transaction"]["DeliveryDetails"]["PostalCode"] = @last_checkout.billing_address.postal_code if @last_checkout.present?
      data["Transaction"]["DeliveryDetails"]["Suburb"] = @last_checkout.present? ? @last_checkout.billing_address.suburb.to_s : " "
      data["Transaction"]["DeliveryDetails"]["Landmark"] = @last_checkout.present? ? @last_checkout.billing_address.landmark.to_s : " "
      data["Transaction"]["DeliveryDetails"]["Street"] = @last_checkout.present? ? @last_checkout.billing_address.street.to_s : " "
      data["Transaction"]["DeliveryDetails"]["UnitNo"] = @last_checkout.billing_address.unit_no if @last_checkout.present?
      data["Transaction"]["DeliveryDetails"]["HouseNo"] = @last_checkout.present? ? @last_checkout.billing_address.house_no.to_s : " "
      data["Transaction"]["DeliveryDetails"]["Complex"] = @last_checkout.billing_address.complex if @last_checkout.present?
      data["Transaction"]["DeliveryDetails"]["PhoneNoAlternate"] = @last_checkout.billing_address.secondary_number if @last_checkout.present?
      data["Transaction"]["DeliveryDetails"]["CustomerName"] = current_user.first_name + " " + current_user.last_name
      data["Transaction"]["DeliveryDetails"]["DeliveryPrice"] = (@sum.to_i * 0.10).to_s
      data["Transaction"]["DeliveryDetails"]["Instructions"] = BillingAddress.where(is_primary: true, user_id: current_user.id).last.instruction if BillingAddress.where(is_primary: true, user_id: current_user.id).present?
      data["Transaction"]["DeliveryDetails"]["Latitude"] = @last_checkout.billing_address.latitude if @last_checkout.present?
      data["Transaction"]["DeliveryDetails"]["Longitude"] = @last_checkout.billing_address.longitude if @last_checkout.present?
      data["Transaction"]["DeliveryDetails"]["PhoneNo"] = current_user.contact_details.to_s
      data["Transaction"]["DeliveryDetails"]["DeliveryDate"] = Time.now.to_s.gsub(" +0000", "")
      # data["Transaction"]["SalesHeader"]["UnitNo"] = (Checkout.where(user_id: current_user.id).last.user_cart.id + 1000).to_s
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
      sftp_path = 'SalesFiles/' + name
      logger.info "=========#{path}=========="
      object = s3.bucket(bucket).object(path)
      object.put(acl: "public-read", bucket: bucket, body: data, content_type: 'application/xml')
      # session = Net::SSH.start('sftp://41.181.180.234', 'thoughtinc', password: 'P@ss@word1', port: 22)
      begin
        Net::SFTP.start('41.181.180.234', 'thoughtinc', password: 'P@ss@word1', port: 22) do |ftp|
          ftp.upload(StringIO.new(data), sftp_path)
          Rails.logger.info("Sales file uploaded.")
        end
        # sftp = Net::SFTP.start('41.181.180.234', 'thoughtinc', password: 'P@ss@word1', port: 22)
        # sftp.connect!
        # # Net::SFTP.start('sftp://41.181.180.234', 'thoughtinc', password: 'P@ss@word1', port: 22) do |sftp|
        # Rails.logger.info("SFTP Connection created, uploading files.")
        # io = StringIO.new(data)
        # sftp.upload!(io, sftp_path)
        # sftp.session.shutdown!
      # end
      rescue Exception => e
        UserMailer.order_confiramtion_email(current_user, @last_checkout, @last_checkout.billing_address, @sum, @shipping_price).deliver
        Rails.logger.info("=========file not uploaded=============")
        Rails.logger.info(e)
      end

    end
  end

  def resend_invoice(checkout)
    @checkout = checkout
    random_number = (SecureRandom.random_number(9e4) + 1e4).to_i
    @billing_address = checkout.billing_addresses.where(is_primary: true).last
    @cart = checkout.last.user_cart.user_cart_products if checkout.present?
    @initial_sum = checkout.user_cart.user_cart_products.pluck(:sub_total).sum if checkout.user.user_carts.present? && checkout.last.user_cart.user_cart_products.present?
    @product_ids = Product.where(id: checkout.user_cart.user_cart_products.pluck(:product_id)).pluck(:product_category_id)
    @category_ids = ProductCategory.where(id: @product_ids).pluck(:category_id) if @product_ids.present?
    @delivery_fee = ProductCategory.where(id: @product_ids).pluck(:delivery_fee).compact.max.to_i if @product_ids.present? && ProductCategory.where(id: @product_ids).pluck(:delivery_fee).present?
    @shipping_price = @initial_sum.to_i < 5000 ? @delivery_fee : 0
    @sum = @initial_sum.to_i + @shipping_price.to_i
    UserMailer.order_confiramtion_email(checkout.user, checkout, @billing_address, @cart, @sum, @shipping_price).deliver
    xml = File.open(Rails.root.join('public', 'Sales.xml'))
    data = Hash.from_xml(xml)
    logger.info "=========#{data}=========="
    _file_name = "Sale_Invoice_#{Time.now.strftime("%Y_%d_%m_%H_%M").to_s}"
    data["Transaction"]["SalesHeader"]["InvoiceNumber"] = (checkout.user_cart.id + 1000).to_s
    data["Transaction"]["SalesHeader"]["DeliveryCharge"] = @shipping_price.to_s
    data["Transaction"]["SalesHeader"]["CustomerName"] = checkout.user.first_name + " " + checkout.user.last_name
    data["Transaction"]["SalesHeader"]["TotalSalePriceAfterDiscount"] = @sum.to_s
    data["Transaction"]["SalesHeader"]["CustomerPin"] = random_number.to_s
    data["Transaction"]["SalesHeader"]["DateOfSale"] = Time.now.to_s.gsub(" +0000", "")
    data["Transaction"]["SalesHeader"]["TotalVAT"] = (@sum.to_i * 0.15).to_s
    data["Transaction"]["Details"]["SalesDetails"] = []
    sale_details = {"StockItemId"=>"14CB7ADA-295E-43FD-AECD-243106D55445", "StockProfile"=>"White", "Quantity"=>"1", "UnitSellingPrice"=>"999.9900", "DiscountPerUnit"=>"0.0000", "UnitPriceAfterDiscount"=>"999.9900", "TotalPriceAfterDiscount"=>"999.9900", "UnitVAT"=>"130.4335"}
    checkout.user_cart.user_cart_products.each_with_index do |product, index|
      sale = []
      sale[index] = {}
      sale[index]["Quantity"] = product.quantity.to_s
      sale[index]["UnitSellingPrice"] = product.product.price.to_s
      sale[index]["StockItemId"] = product.product.stock_item_id.to_s
      sale[index]["StockProfile"] = product.color.title.to_s if product.color.present?
      sale[index]["DiscountPerUnit"] = "0.0".to_s
      sale[index]["UnitPriceAfterDiscount"] = product.product.price.to_s
      sale[index]["TotalPriceAfterDiscount"] = product.product.price.to_s
      sale[index]["UnitVAT"] = (product.product.price.to_i * 0.15).to_s
      data["Transaction"]["Details"]["SalesDetails"] << sale[index]
    end
    @last_checkout = checkout
    # data["Transaction"]["Details"]["SalesDetails"] = data["Transaction"]["Details"]["SalesDetails"].flatten
    data["Transaction"]["DeliveryDetails"]["Province"] = @last_checkout.billing_address.province.title if @last_checkout.present? && @last_checkout.billing_address.province.present?
    data["Transaction"]["DeliveryDetails"]["City"] = @last_checkout.billing_address.city.title if @last_checkout.present? && @last_checkout.billing_address.city.present?
    data["Transaction"]["DeliveryDetails"]["Address"] = @last_checkout.billing_address.address if @last_checkout.present?
    data["Transaction"]["DeliveryDetails"]["PostalCode"] = @last_checkout.billing_address.postal_code if @last_checkout.present?
    data["Transaction"]["DeliveryDetails"]["Suburb"] = @last_checkout.present? ? @last_checkout.billing_address.suburb.to_s : " "
    data["Transaction"]["DeliveryDetails"]["Landmark"] = @last_checkout.present? ? @last_checkout.billing_address.landmark.to_s : " "
    data["Transaction"]["DeliveryDetails"]["Street"] = @last_checkout.present? ? @last_checkout.billing_address.street.to_s : " "
    data["Transaction"]["DeliveryDetails"]["UnitNo"] = @last_checkout.billing_address.unit_no if @last_checkout.present?
    data["Transaction"]["DeliveryDetails"]["HouseNo"] = @last_checkout.present? ? @last_checkout.billing_address.house_no.to_s : " "
    data["Transaction"]["DeliveryDetails"]["Complex"] = @last_checkout.billing_address.complex if @last_checkout.present?
    data["Transaction"]["DeliveryDetails"]["PhoneNoAlternate"] = @last_checkout.billing_address.secondary_number if @last_checkout.present?
    data["Transaction"]["DeliveryDetails"]["CustomerName"] = checkout.user.first_name + " " + checkout.user.last_name
    data["Transaction"]["DeliveryDetails"]["DeliveryPrice"] = (@sum.to_i * 0.10).to_s
    data["Transaction"]["DeliveryDetails"]["Instructions"] = BillingAddress.where(is_primary: true, user_id: checkout.user.id).last.instruction if BillingAddress.where(is_primary: true, user_id: checkout.user.id).present?
    data["Transaction"]["DeliveryDetails"]["Latitude"] = @last_checkout.billing_address.latitude if @last_checkout.present?
    data["Transaction"]["DeliveryDetails"]["Longitude"] = @last_checkout.billing_address.longitude if @last_checkout.present?
    data["Transaction"]["DeliveryDetails"]["PhoneNo"] = checkout.user.contact_details.to_s
    data["Transaction"]["DeliveryDetails"]["DeliveryDate"] = Time.now.to_s.gsub(" +0000", "")
    # data["Transaction"]["SalesHeader"]["UnitNo"] = (checkout.last.user_cart.id + 1000).to_s
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
    sftp_path = 'SalesFiles/' + name
    logger.info "=========#{path}=========="
    object = s3.bucket(bucket).object(path)
    object.put(acl: "public-read", bucket: bucket, body: data, content_type: 'application/xml')
    # session = Net::SSH.start('sftp://41.181.180.234', 'thoughtinc', password: 'P@ss@word1', port: 22)
    begin
      Net::SFTP.start('41.181.180.234', 'thoughtinc', password: 'P@ss@word1', port: 22) do |ftp|
        ftp.upload(StringIO.new(data), sftp_path)
        Rails.logger.info("Sales file uploaded.")
      end
      # sftp = Net::SFTP.start('41.181.180.234', 'thoughtinc', password: 'P@ss@word1', port: 22)
      # sftp.connect!
      # # Net::SFTP.start('sftp://41.181.180.234', 'thoughtinc', password: 'P@ss@word1', port: 22) do |sftp|
      # Rails.logger.info("SFTP Connection created, uploading files.")
      # io = StringIO.new(data)
      # sftp.upload!(io, sftp_path)
      # sftp.session.shutdown!
    # end
    rescue Exception => e
      UserMailer.order_confiramtion_email(checkout.user, @last_checkout, @last_checkout.billing_address, @sum, @shipping_price).deliver
      Rails.logger.info("=========file not uploaded=============")
      Rails.logger.info(e)
    end
    flash[:info] = "Invoice has been sent successfully."
    redirect_back(fallback_location: root_path)
  end

end
