class Admin::CommentsController < AdminController
  before_action :get_comment, only: [:show, :edit, :update, :destroy]

  def index
    @comments = Comment.all
  end

  def new
    @comment = Comment.new
  end

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
            flash[:success] = "Comment Successfully Created"
      redirect_to admin_comments_path
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    if @comment.update(comment_params)
      flash[:success] = "Comment Succesfully Updated"
      redirect_to admin_comments_path
    else
      render 'edit'
    end
  end

  def destroy
    @comment.destroy
    flash[:danger] = "Comment Successfully Deleted"
    redirect_to admin_comments_path
  end

  private

  def comment_params
    params.required(:comment).permit(:statement)
  end

  def get_comment
    @comment = Comment.find(params[:id])
  end
end
