class Admin::ProductTypesController < AdminController
  before_action :get_product_type, only: [:show, :edit, :update, :destroy]

  def index
    @product_types = ProductType.all
  end

  def new
    @product_type = ProductType.new
  end

  def create
    @product_type = ProductType.new(product_type_params)
    if @product_type.save
      flash[:success] = "Product Type Successfully Created"
      redirect_to admin_product_types_path
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    if @product_type.update(product_type_params)
      flash[:success] = "Product Type Succesfully Updated"
      redirect_to admin_product_types_path
    else
      render 'edit'
    end
  end

  def destroy
    @product_type.destroy
    flash[:danger] = "Product Type Successfully Deleted"
    redirect_to admin_product_types_path
  end

  private

  def product_type_params
    params.required(:product_type).permit(:title)
  end

  def get_product_type
    @product_type = ProductType.find(params[:id])
  end
end
