class HomeController < ApplicationController
  def index
    @categories = Category.all
    @blogs = Blog.all.order("created_at DESC")
    @popular_products = Product.most_hit(nil, 100)
    @popular_vendors = User.product_vendors.most_hit(nil,100)
    @advertisements = Advertisement.all.order("created_at DESC")

    category = Category.find_by(title: 'Architects')
    if category.nil?
      @popular_architects = []
    else
      @popular_architects = User.most_hit(nil ,100).vendor.where(category_id: category.id)
    end
    category = Category.find_by(title: 'Interior Designer')
    if category.nil?
      @popular_interior_designers = []
    else
      @popular_interior_designers = User.most_hit(nil ,100).vendor.where(category_id: category.id)
    end
    category = Category.find_by(title: 'Product Designer')
    if category.nil?
      @popular_product_designers = []
    else
      @popular_product_designers = User.most_hit(nil ,100).vendor.where(category_id: category.id)
    end
    @cities = City.all.order("created_at DESC")
  end

  def search
    respond_to do |format|
      format.js {
        @products = Product.search_filter(params[:product_category_id])
      }
      format.html {
        @categories = Category.all
        if params[:q].blank? and params[:location].blank?
          @products = Product.all.paginate(page: params[:page], per_page: 20)
        else
          @products = Product.search(params[:q], params[:location]).paginate(page: params[:page], per_page: 20)
        end
        # @products = User.where(city_id:(params[:city_id])).collect(&:@products).flatten
        @product_categories = ProductCategory.all
        # @product_types = ProductType.all
      }
    end
  end
end
