class ContactUsController < ApplicationController
  def index

  end

  def store_locator
    if params[:search].present?
      @stores = Store.where("store_address ILIKE '%#{params[:search].downcase}%' OR store_city ILIKE '%#{params[:search].downcase}%'")
      @store_cards = @stores
    end
    if params["store"].present?
      @store = Store.find_by_store_name(params["store"])
      @lat_long = []
      # @stores.to_a.each_with_index do |store, index|
        # next if store.lat == nil or store.long == nil
        # @lat_long_1 = []
        @lat_long << @store.store_name.to_s
        @lat_long << @store.lat.to_f
        @lat_long << @store.long.to_f
        # @lat_long << @lat_long_1
      # end
      @lat_long = @lat_long.compact
    end
  end
end
