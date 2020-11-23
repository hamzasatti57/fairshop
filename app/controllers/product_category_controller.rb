class ProductCategoryController < ApplicationController
  def index
    # @product_category = ProductCategory.find(params[:product_category_id])
    # @product_category.punch(request)
    @best_seller_products = Product.where( status: true).limit(5)
    # @products = Product.where(product_category_id: params[:product_category_id]).paginate(page: params[:page], per_page: 21)
    if params[:category].present? && params[:type].present?
      query_1 = "%#{params[:type].gsub("_", " ")}%"
      @category = Category.where("title ILIKE ?", query_1).first
      @product_categories = @category.product_categories
      query = "%#{params[:category].gsub("_", " ")}%"
      @product_category = ProductCategory.where("title ILIKE ?", query)
      if @product_category.count == 1
        @products = Product.where(product_category_id: @product_category.last.id, status: true)
      else
        @products = Product.where(product_category_id: @product_category.pluck(:id), status: true)
      end
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
    elsif params[:type].present?
      query = "%#{params[:type].gsub("_", " ")}%"
      @category = Category.where("title ILIKE ?", query).first
      @product_categories = @category.product_categories
      product_category_ids = []
      @product_categories.each do |product_category|
        @product_cats = ProductCategory.where(title: product_category.title)
        @product_cats.each do |product_cat|
          product_category_ids << product_cat.id
        end
      end
      @products = Product.where(product_category_id: product_category_ids, status: true)
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
      @products = @products.where(status: true)
      if request.format.html? == nil
        render partial: "products"
      end
    else
      if params[:search_query].present?
        @products = Product.where("title ILIKE '%#{params[:search_query]}%' AND status = true")
      else
        @products = Product.where(status: true)
      end
      if request.xhr?
        render partial: "products"
      end
    end
  end

  def brand_products
    @best_seller_products = Product.where( status: true).limit(5)
    if params[:brand].present?
      query = "%#{params[:brand].gsub("_", " ")}%"
      @brand = Company.where("title ILIKE ?", query).first
      @products = @brand.products
      @brand_products = @products
      @product_categories = ProductCategory.where(id: @products.pluck(:product_category_id))
      @category = Category.where(id: @product_categories.pluck(:category_id)).first
      @companies = Company.where(id: @products.pluck(:company_id))
      if params[:brand].present?
        query = "%#{params[:brand].gsub("_", " ")}%"
        @brand = Company.where("title ILIKE ?", query).first
        @products = @products.where(company_id: @brand.id)
      end
      if params[:category].present?
        query = "%#{params[:category].gsub("_", " ")}%"
        @product_category = ProductCategory.where("title ILIKE ?", query).first
        @products = @products.where(product_category_id: @product_category.id)
      end
      if params[:search].present?
        @products = @products.where("title ILIKE '%#{params[:search]}%'")
      end
      if params[:sort_by].present?
        if params[:sort_by] == "Price(low to high)"
          @products = @products.order("price ASC")
        elsif params[:sort_by] == "Price(high to low)"
          @products = @products.order("price DESC")
        else
          @products = @products.order("#{params[:sort_by]} DESC")
        end
      end
    end
  end
end



