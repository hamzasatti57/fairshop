class ProductCategoryController < ApplicationController
  def index
    # @product_category = ProductCategory.find(params[:product_category_id])
    # @product_category.punch(request)
    # @products = Product.where(product_category_id: params[:product_category_id]).paginate(page: params[:page], per_page: 21)
    if params[:type].present?
      query = "%#{params[:type].gsub("_", " ")}%"
      @caterogy = Category.where("title ILIKE ?", query).first
      @products = Product.where(product_category_id: @caterogy.product_categories.pluck(:id))
    elsif params[:brand].present?
      query = "%#{params[:brand].gsub("_", " ")}%"
      @brand = Company.where("title ILIKE ?", query).first
      @products = Product.where(company_id: @brand.id) 
    else
      @products = Product.all
    end
  end
end
