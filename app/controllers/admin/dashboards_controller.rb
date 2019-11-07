class Admin::DashboardsController < AdminController
  def index
    if current_user.display_products?
      @products = current_user.products
    elsif current_user.display_projects?
      @projects = current_user.projects
    end
    respond_to do |format|
      format.html
      format.js {
        if current_user.display_products?
          @product = current_user.products.find(params[:product_project_id])
        elsif current_user.display_projects?
          @project = current_user.projects.find(params[:product_project_id])
        end
      }
    end
  end

end
