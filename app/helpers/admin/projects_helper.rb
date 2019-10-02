module Admin::ProjectsHelper
  def project_form_attributes project
    if Project.exists? project.id
      return { url:  admin_project_path(project), method: :put }
    else
      return { url:  admin_projects_path, method: :post }
    end
  end
end
