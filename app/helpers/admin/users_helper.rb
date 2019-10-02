module Admin::UsersHelper

  def user_form_attributes user
    if User.exists? user.id
      return { url: admin_user_path(user), method: :put }
    else
      return { url: admin_users_path, method: :post }
    end
  end

  def hide_password? user
    user.id.blank?
  end

  def category_options
    Category.all.map{|category| [category.title, category.id]}
  end

  def selected_category user
    user.category.present? ? user.category.id : nil
  end

end
