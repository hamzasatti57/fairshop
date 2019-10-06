class Admin::BlogsController < AdminController
  before_action :get_blog, only: [:show, :edit, :update, :destroy]

  def index
    @blogs = Blog.all
  end

  def new
    @blog = Blog.new
  end

  def create
    @blog = Blog.new(blog_params)
    if @blog.save
      @blog.image.attach(params[:image])
      flash[:success] = "Blog Successfully Created"
      redirect_to admin_blogs_path
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    if @blog.update(blog_params)
      flash[:success] = "Blog Succesfully Updated"
      redirect_to admin_blogs_path
    else
      render 'edit'
    end
  end

  def destroy
    @blog.destroy
    flash[:danger] = "Blog Successfully Deleted"
    redirect_to admin_blogs_path
  end

  private

  def blog_params
    params.required(:blog).permit(:title, :description, :image)
  end

  def get_blog
    @blog = Blog.find(params[:id])
  end
end
