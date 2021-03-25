class Admin::CategoriesController < AdminController
  before_action :get_category, only: [:show, :edit, :update, :destroy]
  def index
    @categories = Category.all.order( 'id ASC' )
  end
  def new
    @category = Category.new
  end
  def create
    params[:category][:category_type] = params[:category][:category_type] == "1" ? "General" : "Home Page"
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = "Category successfully added"
      redirect_to admin_categories_path
    else
      render 'new'
    end
  end
  def edit
  end
  def update
    puts params
    params[:category][:category_type] = params[:category][:category_type] == "1" ? "General" : "Home Page"
    if @category.update(category_params)
      flash[:success] = "Category Successfully Edited"
      redirect_to admin_categories_path
    else
      render 'edit'
    end
  end
  def show
  end

  def destroy
    @category.destroy
    flash[:success] = "Category Deleted"
    redirect_to admin_categories_path
  end
  private
  def category_params
    params.required(:category).permit(:title, :parent_id, :category_type, :shipping_price, :image, :banner_image)
  end
  def get_category
    @category = Category.find(params[:id])
  end
end
