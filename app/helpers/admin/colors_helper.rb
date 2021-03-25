module Admin::ColorsHelper
  def color_form_attributes color
    if Color.exists? color.id
      return { url: admin_color_path(color), method: :put }
    else
      return { url: admin_colors_path, method: :post }
    end
  end
end
