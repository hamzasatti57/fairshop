module ApplicationHelper

  def selected_category_type(form)
    Category.category_types[form.object.category_type]
  end
end
