class LikesController < ApplicationController
  before_action :get_like, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token
  def new
    @like = Like.new
  end

  def create
    if user_signed_in?
      if current_user.customer_likes.where(parent_id: params[:like][:parent_id], parent_type: params[:like][:parent_type]).any?
        @like = current_user.customer_likes.where(parent_id: params[:like][:parent_id], parent_type: params[:like][:parent_type]).first.destroy
        # @like.destroy(value: params[:like][:value])
      else
        @like = current_user.customer_likes.create(like_params)
      end
      @likes_count = @like.parent.likes.count
    end
  end

  private

  def like_params
    params.required(:like).permit(:value, :parent_id, :parent_type, :user_id)
  end

  def get_like
    @like = Like.find(params[:id])
  end
end
