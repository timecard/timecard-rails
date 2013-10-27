class Issue < ActiveRecord::Base
  belongs_to :project
  belongs_to :author, class_name: "User", foreign_key: :author_id
  belongs_to :assignee, class_name: "User", foreign_key: :assignee_id
  has_many :comments
  has_many :work_logs

  validates :subject, presence: true

  def github
    IssueGithub.find_by(
      name: "github",
      provided_type: "Issue",
      provided_id: self.id
    )
  end

  def add_github(number)
    issue_github = IssueGithub.find_or_create_by(
      name: "github",
      provided_type: "Issue",
      provided_id: self.id
    )
    issue_github.number = number
    full_name = self.project.github.full_name
    issue_github.html_url = "https://github.com/#{full_name}/issues/#{number}"
    issue_github.save
  end

  def ruffnote
    IssueRuffnote.find_by(
      name: "ruffnote",
      provided_type: "Issue",
      provided_id: self.id
    )
  end

  def add_ruffnote(number) #index
    issue_ruffnote = IssueRuffnote.find_or_create_by(
      name: "ruffnote",
      provided_type: "Issue",
      provided_id: self.id
    )
    issue_ruffnote.number = number
    full_name = self.project.ruffnote.full_name
    issue_ruffnote.html_url = "https://ruffnote.com/#{full_name}/issues/#{number}"
    issue_ruffnote.save
  end
end
