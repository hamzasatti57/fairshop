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
    data["DocumentElement"]["StockOnHand"].each do |stock|
      @product = Product.find_by_code(stock["StockItemCode"])
      @product_category = ProductCategory.find_by_title("Other")
      color = Color.find_by_title(stock["StockProfile"])
      if color.present?
        color.update!(stock_item_id: stock["StockItemID"])
        @color = color
      else
        @color = Color.create!(stock_item_id: stock["StockItemID"], title: stock["StockProfile"])
      end
      if @product.present?
        @color.products << @product
        # @product.update!(stock_item_id: stock["StockItemID"], stock_category_id: stock["StockCategoryID"], description: stock["StockItemDescription"], stock_profile: stock["StockProfile"], website_item: stock["bWebsiteItem"], website_listing_date: stock["WebsiteListingDate"], website_expiry_date: stock["WebsiteExpiryDate"])
      else
        product = Product.create!( stock_category_id: stock["StockCategoryID"], description: stock["StockItemDescription"], stock_profile: stock["StockProfile"], website_item: stock["bWebsiteItem"], website_listing_date: stock["WebsiteListingDate"], website_expiry_date: stock["WebsiteExpiryDate"], code: stock["StockItemCode"], product_category_id: @product_category.id)
        @color.products << product
      end
    end
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
    puts "=========#{data}=========="
    data["DocumentElement"]["StockOnHand"].each do |stock|
      @color = Color.find_by_stock_item_id(stock["StockItemID"])
      @color.update!(inventory: stock["OnHand"].to_i) if @color.present?
    end
  end
end