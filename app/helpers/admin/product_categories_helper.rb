module Admin::ProductCategoriesHelper
  def product_category_form_attributes product_category
    if ProductCategory.exists? product_category.id
      return { url: admin_product_category_path(product_category), method: :put }
    else
      return { url: admin_product_categories_path, method: :post }
    end
  end
end
