class Admin::CitiesController < AdminController
  before_action :get_city, only: [:show, :edit, :update, :destroy]

  def index
    @cities = City.all
  end

  def new
    @city = City.new
  end

  def create
    @city = City.new(city_params.merge(country_id: 1))
    if @city.save
      flash[:success] = "City Successfully Created"
      redirect_to admin_cities_path
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    if @city.update(city_params)
      flash[:success] = "City Succesfully Updated"
      redirect_to admin_cities_path
    else
      render 'edit'
    end
  end

  def destroy
    @city.destroy
    flash[:danger] = "City Successfully Deleted"
    redirect_to admin_cities_path
  end

  private

  def city_params
    params.required(:city).permit(:title, :country_id, :image)
  end

  def get_city
    @city = City.find(params[:id])
  end
end
