module Admin::CitiesHelper
  def city_form_attributes city
    if City.exists? city.id
      return { url: admin_city_path(city), method: :put }
    else
      return { url: admin_cities_path, method: :post }
    end
  end
  def country_options
    Country.all.map{|country| [country.title, country.id]}
  end
  def selected_country city
    city.country.present? ? city.country.id : nil
  end
end
