class ContactUsController < ApplicationController
  def index

  end

  def store_locator
    if params[:search].present?
      @stores = Store.where("store_address ILIKE '%#{params[:search].downcase}%' OR store_city ILIKE '%#{params[:search].downcase}%'")
      @store_cards = @stores
    else
      @stores = Store.all
    end
    @lat_long = []
    @stores.each_with_index do |store, index|
      next if store.lat == nil or store.long == nil
      @lat_long[index] = []
      @lat_long[index] << store.store_name.to_s
      @lat_long[index] << store.lat.to_f
      @lat_long[index] << store.long.to_f
      @lat_long << @lat_long[index]
    end
    @lat_long = @lat_long.compact
  end
end
