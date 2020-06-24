class Admin::ProductCategoriesController < AdminController
  before_action :get_product_category, only: [:show, :edit, :update, :destroy]

  def index
    @product_categories = ProductCategory.all
  end

  def new
    @product_category = ProductCategory.new
  end

  def create
    @product_category = ProductCategory.new(product_category_params)
    if @product_category.save
      @product_category.punch(request)
      flash[:success] = "Product Category Successfully Created"
      redirect_to admin_product_categories_path
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    if @product_category.update(product_category_params)
      flash[:success] = "Product Category Succesfully Updated"
      redirect_to admin_product_categories_path
    else
      render 'edit'
    end
  end

  def destroy
    @product_category.destroy
    flash[:danger] = "Product Category Successfully Deleted"
    redirect_to admin_product_categories_path
  end

  private

  def product_category_params
    params.required(:product_category).permit(:title, :category_id)
  end

  def get_product_category
    @product_category = ProductCategory.find(params[:id])
  end
end
