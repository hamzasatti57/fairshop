class Admin::ReportsController < AdminController
  def index
    if current_user.display_products?
      @products = current_user.products
    elsif current_user.display_projects?
      @projects = current_user.projects
    end
  end

  def detail_product_project_hits
    if current_user.display_products?
      @products = current_user.products
    elsif current_user.display_projects?
      @projects = current_user.projects
    end
  end

  def detail_product_project_likes
    if current_user.display_products?
      @products = current_user.products
    elsif current_user.display_projects?
      @projects = current_user.projects
    end
  end

  def detail_product_project_comments
    if current_user.display_products?
      @products = current_user.products
    elsif current_user.display_projects?
      @projects = current_user.projects
    end
  end
  def category_reporting
    if current_user.display_products?
      @product_categories = ProductCategory.all
    end
  end

  def user_reporting
    @user = current_user
  end
end
