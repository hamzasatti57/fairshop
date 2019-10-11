module Admin::CitiesHelper
  def city_form_attributes city
    if City.exists? city.id
      return { url: admin_city_path(city), method: :put }
    else
      return { url: admin_cities_path, method: :post }
    end
  end
end
