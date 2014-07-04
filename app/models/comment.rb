class Comment < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }

  belongs_to :issue
  belongs_to :user

  validates :body, presence: true

  after_create :track_public_activity

  def github
    CommentGithub.find_by(
      name: "github",
      provided_type: "Comment",
      foreign_id: self.id
    )
  end

  def add_github(comment_id)
    comment_github = CommentGithub.find_or_create_by(
      name: "github",
      provided_type: "Comment",
      foreign_id: self.id
    )
    comment_github.comment_id = comment_id
    comment_github.save
  end

  def ruffnote
    CommentRuffnote.find_by(
      name: "ruffnote",
      provided_type: "Comment",
      foreign_id: self.id
    )
  end

  def add_ruffnote(comment_id)
    comment_ruffnote  = CommentRuffnote.find_or_create_by(
      name: "ruffnote",
      provided_type: "Comment",
      foreign_id: self.id
    )
    comment_ruffnote.comment_id = comment_id
    comment_ruffnote.save
  end

  private

  def track_public_activity
    self.create_activity(:create, owner: self.issue.project)
  end
end
