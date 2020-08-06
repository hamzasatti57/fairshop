class ConfirmationController < ApplicationController
  def index
    # sleep 1
    # @checkout = Checkout.where(user_id: current_user.id).last if Checkout.where(user_id: current_user.id).present?
    @checkout = Checkout.last if Checkout.count > 0
    @cart = current_user.user_carts.last.user_cart_products if current_user.user_carts.present?
    @sum = current_user.user_carts.last.user_cart_products.pluck(:sub_total).sum if current_user.user_carts.present? && current_user.user_carts.last.user_cart_products.present?
    xml = File.open(Rails.root.join('public', 'Sales.xml'))
    data = Hash.from_xml(xml)
    logger.info "=========#{data}=========="
    _file_name = "Sale_Invoice_#{Time.now.strftime("%Y_%d_%m_%H_%M").to_s}"
    data["Transaction"]["SalesHeader"]["CustomerName"] = params["name_first"]
    data["Transaction"]["SalesHeader"]["TotalSalePriceAfterDiscount"] = params["amount_gross"]
    data["Transaction"]["SalesHeader"]["DateOfSale"] = Time.now.to_s
    sale_detail = {"StockItemId"=>"14CB7ADA-295E-43FD-AECD-243106D55445", "Quantity"=>"1", "UnitSellingPrice"=>"999.9900", "DiscountPerUnit"=>"0.0000", "UnitPriceAfterDiscount"=>"999.9900", "TotalPriceAfterDiscount"=>"999.9900", "UnitVAT"=>"130.4335"}
    data["Transaction"]["Details"]["SalesDetails"] = []
    detail_array = current_user.user_carts.last.user_cart_products.each do |product|
      sale_detail["Quantity"] = product.quantity
      sale_detail["UnitSellingPrice"] = product.product.price
      sale_detail["TotalPriceAfterDiscount"] = product.product.price
    end
    data["Transaction"]["Details"]["SalesDetails"] << detail_array.map(&:attributes)
    data["Transaction"]["Details"]["SalesDetails"] = data["Transaction"]["Details"]["SalesDetails"].flatten
    data["Transaction"]["DeliveryDetails"]["Province"] = current_user.user_carts.last.checkout.billing_address.province.title
    data["Transaction"]["DeliveryDetails"]["City"] = current_user.user_carts.last.checkout.billing_address.city.title
    data["Transaction"]["DeliveryDetails"]["Address"] = current_user.user_carts.last.checkout.billing_address.address
    data["Transaction"]["DeliveryDetails"]["PostalCode"] = current_user.user_carts.last.checkout.billing_address.postal_code
    puts data.to_xml
    FileUtils.rm_rf(Rails.root.join('public/Sales/', "#{_file_name}.xml"))
    File.open("#{Rails.root}/public/Sales/#{_file_name}.xml", "w+b") << data.to_xml
  end
end
