class Admin::AdvertisementsController < AdminController
  before_action :get_advertisement, only: [:show, :edit, :update, :destroy]

  def index
    @advertisements = current_user.advertisements
  end

  def new
    @advertisement = Advertisement.new
  end

  def create
    @advertisement = Advertisement.new(advertisement_params.merge(user_id: current_user.id))
    if @advertisement.save
      flash[:success] = "Advertisement Successfully Created"
      redirect_to admin_advertisements_path
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    if @advertisement.update(advertisement_params)
      flash[:sucess] = "Advertisement Succesfully Updated"
      redirect_to admin_advertisements_path
    else
      render 'edit'
    end
  end

  def destroy
    @advertisment = Advertisement.find(params[:id])
    @advertisment.destroy
    flash[:danger] = "Advertisment Successfully Deleted"
    redirect_to admin_advertisements_path
  end

  private

  def advertisement_params
    params.required(:advertisement).permit(:title, :description, :image, :user_id)
  end

  def get_advertisement
    @advertisement = Advertisement.find(params[:id])
  end
end
