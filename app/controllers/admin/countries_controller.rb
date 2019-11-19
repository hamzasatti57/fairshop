class Admin::CountriesController < AdminController
  skip_before_action :authenticate_user!, only: [:get_cities]
  before_action :get_country, only: [:show, :edit, :update, :destroy]

  def index
    @countries = Country.all.order( 'id ASC' )
  end

  def new
    @country = Country.new
  end

  def create
    @country = Country.new(country_params)
    if @country.save
      # @blog.image.attach(params[:image])
      flash[:success] = "Country Successfully Created"
      redirect_to admin_countries_path
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    if @country.update(country_params)
      flash[:success] = "Country Succesfully Updated"
      redirect_to admin_countries_path
    else
      render 'edit'
    end
  end

  def destroy
    @country.destroy
    flash[:danger] = "Country Successfully Deleted"
    redirect_to admin_countries_path
  end

  def get_cities
    @cities = City.where(country_id: params[:country_id])
  end

  private

  def country_params
    params.required(:country).permit(:title)
  end

  def get_country
    @country = Country.find(params[:id])
  end
end
