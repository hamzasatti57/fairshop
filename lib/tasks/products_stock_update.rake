namespace :products_stock_update do
  desc "TODO"
  task update_stock: :environment do
    s3 = Aws::S3::Resource.new(
        :region => 'us-east-1',
        :access_key_id => 'AKIAJ4TWUFPR24VBAEYA',
        :secret_access_key => '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')
    obj = s3.bucket('fairprice').object('StockFile.xml')
    obj.get(response_target: Rails.root.join("public", "StockFile.xml"))
    xml = File.open(Rails.root.join('public', 'StockFile.xml'))
    data = Hash.from_xml(xml)
    puts "=========#{data}=========="
    ProductColor.destroy_all
    data["DocumentElement"]["StockOnHand"].each do |stock|
      @product = Product.find_by_code(stock["StockItemCode"])
      # @product.product_category.update(stock_category_id: stock["StockCategoryID"]) if @product.product_category.present?
      @product_category = ProductCategory.find_by_stock_category_id(stock["StockCategoryID"])
      @product_category.update(delivery_fee: stock["OnlineDeliveryCharge"].to_f) if @product_category.present? && stock["OnlineDeliveryCharge"].present?
      color = stock["StockProfile"].present? ? Color.where("title = ?", stock["StockProfile"]).last : Color.find_by_title("Default")
      if color.present?
        # color.update!(stock_item_id: stock["StockItemID"], title: stock["StockProfile"])
        @color = color if stock["bDiscontinued"] != "true"
      else
        puts "=========color add=========="
        @color = Color.create!(title: stock["StockProfile"]) if stock["bDiscontinued"] != "true" && stock["StockProfile"] != nil
      end
      if @product.present?
        puts "=========ProductColor add=========="
        ProductColor.create!(product_id: @product.id, color_id: @color.id, stock_item_id: stock["StockItemID"]) unless (@color.present? && ProductColor.where(product_id: @product.id, color_id: @color.id).present?) || @color.blank? || stock["bDiscontinued"] == "true"
        @product.update!(stock_item_id: stock["StockItemID"], stock_category_id: stock["StockCategoryID"], description: stock["StockItemDescription"], stock_profile: stock["StockProfile"], website_item: stock["bWebsiteItem"], website_listing_date: stock["WebsiteListingDate"], website_expiry_date: stock["WebsiteExpiryDate"], price: stock["SellingPrice"], print_description: stock["PrintDescription"], free_home_assembly: stock["bFreeHomeAssembly"])
      else
        puts "=========product add=========="
        # status: stock["bDiscontinued"] == "true" ? false : true
        @product = Product.create!(stock_item_id: stock["StockItemID"], title: stock["StockItemDescription"], stock_category_id: stock["StockCategoryID"], description: stock["StockItemDescription"], stock_profile: stock["StockProfile"], website_item: stock["bWebsiteItem"], website_listing_date: stock["WebsiteListingDate"], website_expiry_date: stock["WebsiteExpiryDate"], price: stock["SellingPrice"], code: stock["StockItemCode"], product_category_id: @product_category.present? ? @product_category.id : nil, print_description: stock["PrintDescription"], free_home_assembly: stock["bFreeHomeAssembly"])
        ProductColor.create!(product_id: @product.id, color_id: @color.id, stock_item_id: stock["StockItemID"]) unless (@color.present? && ProductColor.where(product_id: @product.id, color_id: @color.id).present?) || @color.blank? || stock["bDiscontinued"] == "true"
      end
    end
    StockUpdate.count < 1 ? StockUpdate.create(stock_file: Time.now) : StockUpdate.last.update(stock_file: Time.now)
  end

  desc "TODO"
  task update_inventory: :environment do
    s3 = Aws::S3::Resource.new(
        :region => 'us-east-1',
        :access_key_id => 'AKIAJ4TWUFPR24VBAEYA',
        :secret_access_key => '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')
    obj = s3.bucket('fairprice').object('GP_StockFile.xml')
    obj.get(response_target: Rails.root.join("public", "GP_StockFile.xml"))
    xml = File.open(Rails.root.join('public', 'GP_StockFile.xml'))
    data = Hash.from_xml(xml)
    data["DocumentElement"]["StockOnHand"].each do |stock|
      @color = ProductColor.find_by_stock_item_id(stock["StockItemID"])
      puts "=========inventory updated=========="
      @color.update!(inventory: stock["OnHand"].to_i) if @color.present?
    end
    StockUpdate.count < 1 ? StockUpdate.create(gp_stock_file: Time.now) : StockUpdate.last.update(gp_stock_file: Time.now)
  end
end
