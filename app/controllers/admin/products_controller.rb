class Admin::ProductsController < AdminController
  before_action :load_products, only: :index
  before_action :load_user_product, only: [:new, :create]
  load_and_authorize_resource

  def index
    @products = Product.all
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
      # @product.punch(request)
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

  def bulk_upload_products
    xlsx = Roo::Excelx.new(params["product"]["products"].tempfile, extension: :xlsx)
    xlsx.sheet(0).each_with_index do |row, index|
      next if index == 0
      if Product.where(code: row[0]).present?
        @product = Product.where(code: row[0]).first
        @product.update!(title: row[1], company_id: Company.last.id, description: row[4], product_category_id: ProductCategory.find_or_create_by!(title: row[3], category_id: Category.find_or_create_by!(title: row[2]).id).id, status: false, price: row[5].gsub("R", "").to_f, height: row[6], width: row[7], length: row[8], m2: row[10])
      else
        Product.create!(title: row[1], company_id: Company.last.id, code: row[0], description: row[4], product_category_id: ProductCategory.find_or_create_by!(title: row[3], category_id: Category.find_or_create_by!(title: row[2]).id).id, status: false, price: row[5].gsub("R", "").to_f, height: row[6], width: row[7], length: row[8], m2: row[10])
      end
    end
    flash[:success] = "Products uploaded successfully"
    redirect_to admin_products_path
  end

  def bulk_upload
    @product = Product.new
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
    params.required(:product).permit(:user_id , :title, :description, :inventory, :price, :length, :status, :product_type_id, :code,
                                     :width, :height, :status, :visibility, :company_id, :product_category_id, :clean_and_care, :warranty , :color_id, images: [])

  end

  def get_product
    @product = Product.find(params[:id])
  end
end
