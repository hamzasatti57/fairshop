module Admin::CountriesHelper
  def country_form_attributes country
    if Country.exists? country.id
      return { url: admin_country_path(country), method: :put }
    else
      return { url: admin_countries_path, method: :post }
    end
  end
end
