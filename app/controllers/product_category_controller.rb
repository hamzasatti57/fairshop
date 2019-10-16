class ProductCategoryController < ApplicationController
  def index
    @product_category = ProductCategory.find(params[:product_category_id])
    @products = Product.where(product_category_id: params[:product_category_id]).paginate(page: params[:page], per_page: 21)
  end
end
