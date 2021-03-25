module Admin::CategoriesHelper

  def category_form_attributes category
    if Category.exists? category.id
      return { url: admin_category_path(category), method: :put }
    else
      return { url: admin_categories_path, method: :post }
    end
  end
end
