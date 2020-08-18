module ApplicationHelper

  def selected_category_type(form)
    Category.category_types[form.object.category_type]
  end

  def product_attributes product
    { id: product.id, title: product.title, file_name: rails_blob_url(product.images.first) }.to_json
  end
end
