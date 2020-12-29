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
      # unless current_user.user_carts.where(status: 0).present? && current_user.user_carts.where(status: 0).last.user_cart_products.pluck(:product_id).include?(@product.id)
      unless current_user.user_carts.where(status: 0).present? && current_user.user_carts.where(status: 0).last.user_cart_products.pluck(:product_id, :color_id).include?([params[:id].to_i, params[:color].to_i])
        @user_cart = current_user.user_carts.where(status: 0).blank? ? UserCart.create!(user_id: current_user.id) : current_user.user_carts.where(status: 0).last
        current_user.user_cart_products.create!(product_id: @product.id, quantity: params[:quantity].present? ? params[:quantity].to_i : 1, color_id: params[:color].present? ? params[:color].to_i : 1, sub_total: @product.price * (params[:quantity].present? ? params[:quantity].to_i : 1), user_cart_id: @user_cart.id)
        # flash[:success] = "Product added to cart"
        flash[:add_to_cart] = true
        redirect_back(fallback_location: root_path)
      else
        flash[:error] = "This product is already in your cart."
        redirect_back(fallback_location: root_path)
      end
    else
      session[:last_url] = request.referrer
      flash[:error] = "Need to login first"
      redirect_to new_user_session_path
    end
  end

  def save_cart
    params["cart_object"].keys.each_with_index do |cart_id, index|
      @user_cart_product = UserCartProduct.find_by_id(cart_id.to_i)
      @user_cart_product.update(quantity: params["cart_object"]["#{cart_id.to_i}"], sub_total: @user_cart_product.product.price * params["cart_object"]["#{cart_id.to_i}"].to_f)
    end
    @sum = current_user.user_carts.where(status: 0).last.user_cart_products.pluck(:sub_total).sum if current_user.user_carts.where(status: 0).present? && current_user.user_carts.where(status: 0).last.user_cart_products.present?
    render :json => @sum
  end

  def get_comments
    @product = Product.find(params[:id])
    @comment = @product.comments.last
    render :json => @comment.attributes.merge( "date" => @comment.created_at.strftime("%b %d, %Y %I:%M %P"))
  end

  def favourites
    @products = Product.where(id: current_user.customer_likes.pluck(:parent_id))
  end

  def show
    @product = Product.find(params[:id])
    # @product.punch(request)
    # @vendor = @product.user
    @best_seller_products = Product.where( status: true).limit(5)
    # @vendor.punch(request)
    # @products = @vendor.products.where(visibility: true)
    @likes = @product.likes
    @comments = @product.comments.order("created_at DESC")
    @avg_rating = @product.ratings.average(:value)
    if user_signed_in?
      if current_user.customer_ratings.where(parent_id: @product.id, parent_type: Rating.parent_type_product).any?
        @rating = current_user.customer_ratings.where(parent_id: @product.id, parent_type: 0).first
      end
    end

  end

  def promotions
    @best_seller_products = Product.where( status: true).limit(5)
      @products = Product.where( status: true, is_discounted: true)
      @product_categories = ProductCategory.where(id: @products.pluck(:product_category_id))
      @brand_products = @products
      @companies = Company.where(id: @products.pluck(:company_id))
      if params[:brand].present?
        query = "%#{params[:brand].gsub("_", " ")}%"
        @brand = Company.where("title ILIKE ?", query).first
        @products = @products.where(company_id: @brand.id)
      end
      if params[:search].present?
        @products = @products.where("title ILIKE '%#{params[:search]}%'")
      end
      if params[:min_val].present? && params[:max_val].present?
        @products = @products.where(:price => (params[:min_val].to_f..params[:max_val].to_f))
      end
      if params[:sort_by].present?
        if params[:sort_by] == "Price(low to high)"
          @products = @products.order("price ASC")
        elsif params[:sort_by] == "Price(high to low)"
          @products = @products.order("price DESC")
        elsif params[:sort_by] == "Newest"
          @products = @products.order("created_at DESC")
        end
      else
        @products = @products.order("price ASC")
      end
      if request.xhr?
        render partial: "products"
      end
    # @popular_products = Product.most_hit(nil, 100).where(visibility: true).paginate(page: params[:page], per_page: 21)
  end

  def product_detail
    @product = Product.find_by_id(params[:id])
    if @product.blank?
      flash[:error] = "Product not found."
      return redirect_to root_path
    end
  end

  def update_download_catalog_count
    @user = User.find(params[:user_id])
    @user.profile.update(catalog_download_count: @user.profile.catalog_download_count+1)
  end
end
