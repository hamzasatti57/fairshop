class Admin::ProfilesController < AdminController

  before_action :load_profiles, only: :index
  before_action :load_user_profile, only: [:new, :create]
  load_and_authorize_resource
  def index
    # @profiles = Profile.all
  end
  def new
    # @profile = Profile.new
  end
  def create
    # @profile = Profile.new(profile_params)

    if @profile.save
      # @profile.image.attach(params[:image])
      flash[:success] = "Profile successfully added"
      # redirect_to
    else
      render 'new'
    end
  end
  def edit
  end
  def update
    if @profile.update(profile_params)
      flash[:success] = "Profile Successfully Edited"
      redirect_to
    else
      render 'edit'
    end
  end
  def show
  end

  def destroy
    @profile.destroy
    flash[:success] = "Profile Deleted"
    render 'show'
  end
  private
  def load_user_profile
    if action_name == 'new'
      @profile = current_user.profiles.new
    elsif action_name == 'create'
      @profile = current_user.profiles.new(profile_params)
    end
  end

  def load_profiles
    @profiles = Profile.accessible_by(current_ability)
  end

  def profile_params
    params.required(:profile).permit(:facebook, :instagram,:twitter,:gender,:dob,:phone, :address,:description, :user_id, :image, :pdf)
  end
  def get_profile
    @profile = Profile.find(params[:id])
  end
end
