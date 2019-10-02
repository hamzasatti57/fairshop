module Admin::ProductsHelper
  def product_form_attributes product
    if Product.exists? product.id
      return {url: admin_product_path(product), method: :put}
    else
      return {url: admin_products_path, method: :post}
    end
  end

end
