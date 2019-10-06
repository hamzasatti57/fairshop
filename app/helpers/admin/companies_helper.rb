module Admin::CompaniesHelper
  def company_form_attributes company
    if Company.exists? company.id
      return { url: admin_company_path(company), method: :put }
    else
      return { url: admin_companies_path, method: :post }
    end
  end
end
