module Admin::ProductTypesHelper
  def product_type_form_attributes product_type
    if ProductType.exists? product_type.id
      return { url: admin_product_type_path(product_type), method: :put }
    else
      return { url: admin_product_types_path, method: :post }
    end
  end
end
