class Admin::ProductsController < AdminController
  before_action :load_products, only: :index
  before_action :load_user_product, only: [:new, :create]
  load_and_authorize_resource

  def index
    # @products = current_user.products
  end

  def show

  end

  def new
    # @product = current_user.products.new
  end

  def create
    # @product = current_user.products.new(product_params)
    @product = current_user.products.new(product_params.merge(company_id: current_user.companies.first.id))
    if @product.save
      @product.add_colors params[:product][:color_ids]
      # if @product.images.attached?
      #   @product.images.attach(params[:product][:images])
      # end
      flash[:success] = "Product successfully created"
      render 'show'
    else
      render 'new'
    end

  end

  def edit

  end

  def update
    if @product.update(product_params)
      @product.update_colors params[:product][:color_ids]
      flash[:success] = "Product Updated Succesfully"
      render 'show'
    else
      render 'edit'
    end
  end

  def destroy
    @product.destroy
    flash[:danger] = "Product Successfully Deleted"
    redirect_to admin_products_path
  end

  def delete_image_attachment
    product = Product.find(params[:id])
    @image = ActiveStorage::Blob.find_signed(params[:image_id])
    @image.attachments.destroy_all

    respond_to do |format|
      format.html { redirect_to edit_admin_product_path(product)}
      format.json { head :no_content }
      format.js
    end

  end

  private
  def load_user_product
    # if action_name == 'new'
    #   @product = current_user.products.new
    # elsif action_name == 'create'
    #   @product = current_user.products.new(product_params)
    # end
    @products = Product.new
  end

  def load_products
    @products = Product.accessible_by(current_ability)
  end

  def product_params
    params.required(:product).permit(:user_id , :title, :description, :inventory, :price, :length,
                                     :width, :height, :status, :visibility, :product_category_id, :color_id, images: [])

  end

  def get_product
    @product = Product.find(params[:id])
  end
end
