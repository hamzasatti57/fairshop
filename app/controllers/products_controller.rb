class ProductsController < ApplicationController

  def index
    @user = User.find(params[:user_id])
    @user.punch(request)
    @products = @user.products.where(visibility: true).paginate(page: params[:page], per_page: 21)
  end

  def show
    @product = Product.find(params[:id])
    @product.punch(request)
    @vendor = @product.user
    @vendor.punch(request)
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
    @popular_products = Product.most_hit(nil, 100).where(visibility: true).paginate(page: params[:page], per_page: 21)
  end
  def update_download_catalog_count
    @user = User.find(params[:user_id])
    @user.profile.update(catalog_download_count: @user.profile.catalog_download_count+1)
  end
end
