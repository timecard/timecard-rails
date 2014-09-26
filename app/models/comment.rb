class Comment < ActiveRecord::Base
  include PublicActivity::Model

  belongs_to :issue
  belongs_to :user

  validates :body, presence: true

  after_create :track_public_activity, :create_github_comment
  after_update :update_github_comment
  before_destroy :destroy_github_comment

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
    comment_github.save!
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
    self.create_activity(:create, owner: self.user, recipient: self.issue.project)
  end

  def create_github_comment
    if issue.github && user.github
      owner, repo = issue.project.github.full_name.split("/")
      client = Github.new(oauth_token: user.github.oauth_token)
      comment = client.issues.comments.create(
        owner, repo, issue.github.number, body: body
      )
      add_github(comment.id)
    end
  end

  def update_github_comment
    if github && user.github
      owner, repo = issue.project.github.full_name.split("/")
      client = Github.new(oauth_token: user.github.oauth_token)
      options = {}
      options["body"] = body
      comment = client.issues.comments.edit(
        owner, repo, github.comment_id, options
      )
      add_github(comment.id)
    end
  end

  def destroy_github_comment
    if github && user.github
      owner, repo = issue.project.github.full_name.split("/")
      client = Github.new(oauth_token: user.github.oauth_token)
      client.issues.comments.delete(
        owner, repo, github.comment_id
      )
    end
  end
end
