class ProductsController < ApplicationController

  def index
    @user = User.find(params[:user_id])
    @user.punch(request)
    @products = @user.products.paginate(page: params[:page], per_page: 21)
  end

  def show
    @product = Product.find(params[:id])
    @product.punch(request)
    @vendor = @product.user
    @vendor.punch(request)
    @products = @vendor.products
    @comments = @product.comments.order("created_at DESC")
    @avg_rating = @product.ratings.average(:value)
    if user_signed_in?
      if current_user.customer_ratings.where(parent_id: @product.id, parent_type: Rating.parent_type_product).any?
        @rating = current_user.customer_ratings.where(parent_id: @product.id, parent_type: 0).first
      end
    end

  end

  def popular_list
    @popular_products = Product.most_hit(nil, 100).paginate(page: params[:page], per_page: 21)
  end
end
