class BlogsController < ApplicationController

  def index
    @blogs = Blog.all.paginate(page: params[:page], per_page: 20)
    @popular_blogs = Blog.all.most_hit(nil, 10)
  end

  def show
    @blog = Blog.find(params[:id])
    @blog.punch(request)
  end

  def search
    if params[:q].blank?
      @blogs = Blog.all.paginate(page: params[:page], per_page: 20)
    else
      @blogs = Blog.search(params[:q]).paginate(page: params[:page], per_page: 20)
    end
    @popular_blogs = Blog.all.most_hit(nil, 10)
  end
end
