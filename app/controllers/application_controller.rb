class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    params[:user][:role] = 1 if (controller_name == 'registrations' && action_name == 'create')
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role, :first_name,:last_name, :username, :contact_details, :category_id, :country_id])
  end
	# before_action :authenticate_user!
  def after_sign_up_path_for(resource)
    if resource.is_admin?
      admin_users_path
    elsif resource.is_vendor?
      admin_profile_path resource.profile
    end
  end

  def after_sign_in_path_for(resource)
    if resource.is_admin?
      admin_users_path
    elsif resource.is_vendor?
      admin_profile_path resource.profile
    end
  end

  def after_sign_out_path_for(resource)

    root_path

  end

end
