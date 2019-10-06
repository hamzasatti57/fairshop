module Admin::ProductsHelper
  def product_form_attributes product
    if Product.exists? product.id
      return {url: admin_product_path(product), method: :put}
    else
      return {url: admin_products_path, method: :post}
    end
  end

  def product_category_options
    ProductCategory.all.map{|product_category| [product_category.title, product_category.id]}
  end

  def selected_product_category product
    product.product_category.present? ? product.product_category.id : nil
  end

  def product_type_options
    ProductType.all.map{|product_type| [product_type.title, product_type.id]}
  end

  def selected_product_type product
    product.product_type.present? ? product.product_type.id : nil
  end

  def color_options
    Color.all.map{|color| [color.title, color.id]}
  end

  def selected_color product
    product.color.present? ? product.color.id : nil
  end

end
