class CommentRuffnote < Provider
  store_into :info do |a|
    comment_id
  end

  def comment
    Comment.find(self.foreign_id)
  end
  
  def destroy(token)
    fn = self.comment.issue.project.ruffnote.full_name
    number = self.comment.issue.ruffnote.number
    Provider.ruffnote(token).delete(
      "/api/v1/#{fn}/issues/#{number}/comments/#{self.comment_id}"
    ).parsed
  end

end
