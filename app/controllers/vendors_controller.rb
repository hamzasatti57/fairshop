class VendorsController < ApplicationController
  def index
    @category = Category.find(params[:category_id])
    @vendors = User.vendors.where(category: @category).paginate(page: params[:page], per_page: 21)
  end

  def popular_list
    @popular_vendors = User.most_hit(nil,100).paginate(page: params[:page], per_page: 21)
  end

  def popular_architect
    category = Category.find_by(title: 'Architects')
    if category.nil?
      @popular_architects = nil
    else
      @popular_architects = User.most_hit(nil ,100).vendor.where(category_id: category.id).paginate(page: params[:page], per_page: 21)
    end
  end

  def popular_interior_designer
    category = Category.find_by(title: 'Interior Designer')
    if category.nil?
      @popular_interior_designers = nil
    else
      @popular_interior_designers = User.most_hit(nil ,100).vendor.where(category_id: category.id).paginate(page: params[:page], per_page: 20)
    end
  end
end