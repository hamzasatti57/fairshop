class ProductCategoryController < ApplicationController
  def index
    # @product_category = ProductCategory.find(params[:product_category_id])
    # @product_category.punch(request)
    # @products = Product.where(product_category_id: params[:product_category_id]).paginate(page: params[:page], per_page: 21)
    if params[:category].present? && params[:type].present?
      query_1 = "%#{params[:type].gsub("_", " ")}%"
      @category = Category.where("title ILIKE ?", query_1).first
      @product_categories = @category.product_categories
      query = "%#{params[:category].gsub("_", " ")}%"
      @product_category = ProductCategory.where("title ILIKE ?", query).first
      @products = Product.where(product_category_id: @product_category.id)
      @brand_products = @products
      @companies = Company.where(id: @products.pluck(:company_id))
      if params[:brand].present?
        query = "%#{params[:brand].gsub("_", " ")}%"
        @brand = Company.where("title ILIKE ?", query).first
        @products = @products.where(company_id: @brand.id)
      end
    elsif params[:type].present?
      query = "%#{params[:type].gsub("_", " ")}%"
      @category = Category.where("title ILIKE ?", query).first
      @product_categories = @category.product_categories
      @products = Product.where(product_category_id: @category.product_categories.pluck(:id))
      @brand_products = @products
      @companies = Company.where(id: @products.pluck(:company_id))
      if params[:brand].present?
        query = "%#{params[:brand].gsub("_", " ")}%"
        @brand = Company.where("title ILIKE ?", query).first
        @products = @products.where(company_id: @brand.id)
      end
    else
      @products = Product.all
    end
  end
end
