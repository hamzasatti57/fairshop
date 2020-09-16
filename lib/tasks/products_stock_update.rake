namespace :products_stock_update do
  desc "TODO"
  task update_stock: :environment do
    xml = File.open(Rails.root.join('/var/sftp/uploads', 'StockFile.xml'))
    data = Hash.from_xml(xml)
    puts "=========#{data}=========="
    data["DocumentElement"]["StockOnHand"].each do |stock|
      @product = Product.find_by_code(stock["StockItemCode"])
      if @product.present?
        @product.update!(stock_item_id: stock["StockItemID"], stock_category_id: stock["StockCategoryID"], description: stock["StockItemDescription"], stock_profile: stock["StockProfile"], website_item: stock["bWebsiteItem"], website_listing_date: stock["WebsiteListingDate"], website_expiry_date: stock["WebsiteExpiryDate"])
      else
        Product.create!(stock_item_id: stock["StockItemID"], stock_category_id: stock["StockCategoryID"], description: stock["StockItemDescription"], stock_profile: stock["StockProfile"], website_item: stock["bWebsiteItem"], website_listing_date: stock["WebsiteListingDate"], website_expiry_date: stock["WebsiteExpiryDate"], code: stock["StockItemCode"])
      end
    end
  end

  desc "TODO"
  task update_inventory: :environment do
    xml = File.open(Rails.root.join('/var/sftp/uploads', 'GP_StockFile.xml'))
    data = Hash.from_xml(xml)
    puts "=========#{data}=========="
    data["DocumentElement"]["StockOnHand"].each do |stock|
      @product = Product.find_by_stock_item_id(stock["StockItemID"])
      @product.update!(inventory: stock["OnHand"].to_i)
    end

  end

end
