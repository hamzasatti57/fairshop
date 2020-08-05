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

  def city_options user
    user.present? ? (user.city.present? ? City.where(country_id: user.city.country.id).map{|city| [city.title, city.id]} : []) : nil
  end

  # def selected_city user
  #   user.present? ? (user.city.present? ? user.city.id : nil) : nil
  # end

  def country_options
    Country.all.map{|country| [country.title, country.id]}
  end

  # def selected_country user
  #   user.present? ? (user.city.present? ? user.city.country.id : nil) : nil

  # end

end
