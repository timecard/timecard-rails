class CommentGithub < Provider
  store_into :info do |a|
    comment_id
  end

  def comment
    Comment.find(self.foreign_id)
  end
end
