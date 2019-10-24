class RatingsController < ApplicationController
  before_action :get_rating, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token
  def new
    @rating = Rating.new
  end

  def create
    if user_signed_in?
      if current_user.customer_ratings.where(parent_id: params[:rating][:parent_id], parent_type: params[:rating][:parent_type]).any?
        @rating = current_user.customer_ratings.where(parent_id: params[:rating][:parent_id], parent_type: params[:rating][:parent_type]).first
        @rating.update(value: params[:rating][:value])
      else
        @rating = current_user.customer_ratings.create(rating_params)
      end
      # @comments_count = @rating.parent.comments.count
    end
  end

  private

  def rating_params
    params.required(:rating).permit(:value, :parent_id, :parent_type, :user_id)
  end

  def get_rating
    @rating = Rating.find(params[:id])
  end
end
