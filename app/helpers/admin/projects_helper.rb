module Admin::ProjectsHelper
  def project_form_attributes project
    if Project.exists? project.id
      return { url:  admin_project_path(project), method: :put }
    else
      return { url:  admin_projects_path, method: :post }
    end
  end
  def company_options
    current_user.companies.all.map{|company| [company.title, company.id]}
    # current_user.Company.all.map{|company| [company.title, company.id]}
  end

  def selected_company project
    project.company.present? ? project.company.id : nil
  end
end
