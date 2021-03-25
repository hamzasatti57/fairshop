module Admin::CommentsHelper
  def comment_form_attributes comment
    if Comment.exists? comment.id
      return { url: admin_comment_path(comment), method: :put }
    else
      return { url: admin_comments_path, method: :post }
    end
  end
end
