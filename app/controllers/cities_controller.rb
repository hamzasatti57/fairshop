class CitiesController < ApplicationController
  def index
    @cities = City.all
  end

  def show
    @city = City.find(params[:id])
    @vendors = User.vendors.where(city: @city)
  end
end
