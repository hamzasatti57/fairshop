class HomeController < ApplicationController
  def index
    @categories = Category.all
    @blogs = Blog.all
    @popular_products = Product.most_hit(nil, 100)
    @popular_vendors = User.most_hit(nil,100)
    category = Category.find_by(title: 'Architects')
    if category.nil?
      @popular_architects = nil
    else
      @popular_architects = User.most_hit(nil ,100).vendor.where(category_id: category.id)
    end
    category = Category.find_by(title: 'Interior Designer')
    if category.nil?
      @popular_interior_designers = nil
    else
      @popular_interior_designers = User.most_hit(nil ,100).vendor.where(category_id: category.id)
    end
    @cities = City.all
  end

  def search
    respond_to do |format|
      format.js {
        @products = Product.search_filter(params[:product_category_id], params[:product_type_id], params[:price_range])
      }
      format.html {
        @categories = Category.all
        if params[:q].blank? and params[:location].blank?
          @products = Product.all
        else
          @products = Product.search(params[:q], params[:location])
        end


        # @products = User.where(city_id:(params[:city_id])).collect(&:@products).flatten
        @product_categories = ProductCategory.all
        @product_types = ProductType.all
      }
    end
  end
end
