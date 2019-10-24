class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :get_data

  def get_data
    @product_categories = ProductCategory.all
  end
  protected

  def configure_permitted_parameters
    params[:user][:role] = params[:user][:role].to_i if params[:user].present?
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role, :first_name,:last_name, :username, :contact_details, :category_id, :city_id, :country_id])
  end
  # before_action :authenticate_user!
  def after_sign_up_path_for(resource)
    if resource.is_admin?
      admin_users_path
    elsif resource.is_vendor?
      admin_profile_path resource.profile
    elsif resource.is_customer?
      root_path
    end
  end

  def after_sign_in_path_for(resource)
    if resource.is_admin?
      admin_users_path
    elsif resource.is_vendor?
      admin_profile_path resource.profile
    elsif resource.is_customer?
      root_path
    end
  end

  def after_sign_out_path_for(resource)
    root_path
  end
end
