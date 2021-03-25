module ProjectsHelper
  def like_count(project, start_date, end_data)
    project.likes.where('created_at BETWEEN ? AND ?', start_date, end_data).count
  end
  def comment_count(project, start_date, end_data)
    project.comments.where('created_at BETWEEN ? AND ?', start_date, end_data).count
  end
end
