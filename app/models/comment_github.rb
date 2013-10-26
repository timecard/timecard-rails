class CommentGithub < Provider
  store_into :info do |a|
    comment_id
  end

  def comment
    Comment.find(self.provided_id)
  end
  
  def destroy(token)
    fn = self.comment.issue.project.github.full_name.gsub(/  /,"").split("/")
    Provider.github(token).issues.comments.delete(
      fn[0], fn[1], self.comment_id
    )
  end

  def modify(token, params)
    options = {}
    options["body"] = params[:body] if params[:body]
    fn = self.comment.issue.project.github.full_name.gsub(/  /,"").split("/")
    comment = Provider.github(token).issues.comments.edit(
      fn[0], fn[1], self.comment_id, options
    )
  end
end
