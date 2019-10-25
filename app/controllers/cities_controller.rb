class CitiesController < ApplicationController
  def index
    @cities = City.all.paginate(page: params[:page], per_page: 20)
  end

  def show
    @city = City.find(params[:id])
    @vendors = User.product_vendors.where(city: @city)
  end
end
