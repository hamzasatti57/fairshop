class ProductsController < ApplicationController

  def index
    @user = User.find(params[:user_id])
    # @user.punch(request)
    # @products = @user.products.where(visibility: true).paginate(page: params[:page], per_page: 21)
    respond_to do |format|
      format.js {
        @products = Product.search_filter(params[:product_category_id]).paginate(page: params[:page], per_page: 21)

      }
      format.html {
        @categories = Category.all
        # if params[:q].blank? and params[:location].blank?
        #   @products = Product.all.paginate(page: params[:page], per_page: 20)
        # else
        #   @products = Product.search(params[:q], params[:location]).paginate(page: params[:page], per_page: 20)
        # end
        # @products = User.where(city_id:(params[:city_id])).collect(&:@products).flatten
        @products = @user.products.where(visibility: true).paginate(page: params[:page], per_page: 21)
        @product_categories = ProductCategory.all
        # @product_types = ProductType.all
      }
    end
  end

  def add_to_cart
    if current_user.present?
      @product = Product.find(params[:id])
      unless current_user.user_cart_products.pluck(:product_id).include?(@product.id)
        current_user.user_cart_products.create(product_id: @product.id, quantity: 1, sub_total: @product.price)
        flash[:success] = "Product added to card"
        redirect_to cart_index_path
      else
        flash[:error] = "This product is already in your cart."
        redirect_back(fallback_location: root_path)
      end
    else
      flash[:error] = "Need to login first"
      redirect_back(fallback_location: root_path)
    end
  end

  def show
    @product = Product.find(params[:id])
    # @product.punch(request)
    @vendor = @product.user
    # @vendor.punch(request)
    @products = @vendor.products.where(visibility: true)
    @likes = @product.likes
    @comments = @product.comments.order("created_at DESC")
    @avg_rating = @product.ratings.average(:value)
    if user_signed_in?
      if current_user.customer_ratings.where(parent_id: @product.id, parent_type: Rating.parent_type_product).any?
        @rating = current_user.customer_ratings.where(parent_id: @product.id, parent_type: 0).first
      end
    end

  end

  def popular_list
    # @popular_products = Product.most_hit(nil, 100).where(visibility: true).paginate(page: params[:page], per_page: 21)
  end
  def update_download_catalog_count
    @user = User.find(params[:user_id])
    @user.profile.update(catalog_download_count: @user.profile.catalog_download_count+1)
  end
end
