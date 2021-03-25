module Admin::BlogsHelper
  def blog_form_attributes blog
    if Blog.exists? blog.id
      return { url: admin_blog_path(blog), method: :put }
    else
      return { url: admin_blogs_path, method: :post }
    end
  end
end
