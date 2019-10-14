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
  end

  def popular_list
    @popular_products = Product.most_hit(nil, 100).paginate(page: params[:page], per_page: 21)
  end
end
