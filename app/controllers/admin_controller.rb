class AdminController < ActionController::Base
  before_action :authenticate_user!

  layout "admin_layout"

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

end
