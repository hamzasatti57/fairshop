class AdvertisementsController < ApplicationController
  def index
    @advertisements = Advertisement.all.paginate(page: params[:page], per_page: 20)
    # @popular_advertisements = Advertisement.all.most_hit(nil, 10)
  end

  def show
    @advertisement = Advertisement.find(params[:id])
    # @advertisement.punch(request)
    @ad_next = @advertisement.next
    @ad_prev = @advertisement.prev
  end

end
