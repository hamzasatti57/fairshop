class ContactUsController < ApplicationController
  def index

  end

  def store_locator
    @stores = Store.all
    @lat_long = []
    @stores.each_with_index do |store, index|
      next if store.lat == nil or store.long == nil
      @lat_long[index] = []
      @lat_long[index] << store.store_name
      @lat_long[index] << store.lat
      @lat_long[index] << store.long
    end
  end
end
