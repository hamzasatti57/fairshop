class CommentsController < ApplicationController
  before_action :get_comment, only: [:show, :edit, :update, :destroy]
  def new
    @comment = Comment.new
  end

  def create
    if user_signed_in?
      @comment = current_user.customer_comments.create(comment_params)
      @comments_count = @comment.parent.comments.count
    end
  end

  private

  def comment_params
    params.required(:comment).permit(:statement, :parent_id, :parent_type, :user_id, :commentor_full_name, :commentor_email_address, :commentor_phone_number)
  end

  def get_comment
    @comment = Comment.find(params[:id])
  end
end
