module ProductsHelper
  def like_count(product, start_date, end_data)
    product.likes.where('created_at BETWEEN ? AND ?', start_date, end_data).count
  end
  def comment_count(product, start_date, end_data)
    product.comments.where('created_at BETWEEN ? AND ?', start_date, end_data).count
  end
end
