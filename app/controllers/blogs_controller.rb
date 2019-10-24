class BlogsController < ApplicationController

  def index
    respond_to do |format|
      format.js {
        if params[:q].blank?
          @blogs = Blog.all.paginate(page: params[:page], per_page: 20)
        else
          @blogs = Blog.search(params[:q]).paginate(page: params[:page], per_page: 20)
        end
        render 'search'
      }
      format.html {
        @blogs = Blog.all.paginate(page: params[:page], per_page: 20)
        @popular_blogs = Blog.all.most_hit(nil, 10)
      }
    end

  end

  def show
    @blog = Blog.find(params[:id])
    @blog.punch(request)
    @blog_next = @blog.next
    @blog_prev = @blog.prev

  end

  def search

    @popular_blogs = Blog.all.most_hit(nil, 10)
  end
end
