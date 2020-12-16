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

  def banner_form
    @product = Product.new
  end

  def edit_banner_form
    @product = Product.find(params[:id])
  end

  def banner_product
    @product = Product.find(params[:id])
  end

  def home_banners
    @products = Product.where(is_promotional_banner: true, product_type_id: 1)
  end

  def create
    # @product = current_user.products.new(product_params)
    if params["product_id"] != ""
      @product = Product.find_by_id(params["product_id"])
      @product.update(is_promotional_banner: true, product_type_id: 1)
    else
      params[:status] = true if params[:images].present?
      params["product"]["is_promotional_banner"] = true
      params["product"]["product_type_id"] = 1
      @product = current_user.products.new(product_params)
      @product.save(validate: false)
    end
    if @product.present?
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
    params[:status] = true if params[:images].present?
    if @product.update(product_params)
      @product.update_colors params[:product][:color_ids]
      flash[:success] = "Product Updated Succesfully"
      if @product.is_promotional_banner
        redirect_to admin_banner_product_path(@product)
      else
        render 'show'
      end
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
    product.images.where(id: params["image_id"]).destroy_all

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
        @product.update!(title: row[1], company_id: Company.first.id, description: row[4], product_category_id: ProductCategory.find_or_create_by!(title: row[3], category_id: Category.find_or_create_by!(title: row[2]).id).id, status: false, price: row[5].gsub("R", "").to_f, height: row[6], width: row[7], length: row[8], m2: row[10])
      else
        Product.create!(title: row[1], company_id: Company.first.id, code: row[0], description: row[4], product_category_id: ProductCategory.find_or_create_by!(title: row[3], category_id: Category.find_or_create_by!(title: row[2]).id).id, status: false, price: row[5].gsub("R", "").to_f, height: row[6], width: row[7], length: row[8], m2: row[10])
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
    params.required(:product).permit(:user_id , :title, :description, :inventory, :price, :length, :status, :product_type_id, :code, :assembly_type,
                                     :width, :height, :status, :visibility, :company_id, :product_category_id, :clean_and_care, :warranty, :is_discounted, :is_promotional_banner, :print_description, :color_id, :default_image, images: [])

  end

  def get_product
    @product = Product.find(params[:id])
  end
end
