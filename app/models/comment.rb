class Comment < ActiveRecord::Base
  belongs_to :issue
  belongs_to :user

  def github
    CommentGithub.find_by(
      name: "github",
      provided_type: "Comment",
      provided_id: self.id
    )
  end

  def add_github(comment_id)
    comment_github = CommentGithub.find_or_create_by(
      name: "github",
      provided_type: "Comment",
      provided_id: self.id
    )
    comment_github.comment_id = comment_id
    comment_github.save
  end
end
