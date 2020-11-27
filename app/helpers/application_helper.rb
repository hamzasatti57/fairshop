module ApplicationHelper

  def selected_category_type(form)
    Category.category_types[form.object.category_type]
  end

  def product_attributes product
    { id: product.id, title: product.title, file_name: rails_blob_url(product.images.first) }.to_json
  end

  def number_with_precisions number
    "R" + number.to_s + "0"
  end
end
