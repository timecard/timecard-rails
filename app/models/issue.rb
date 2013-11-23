class Issue < ActiveRecord::Base
  default_scope { order("updated_at DESC") }

  scope :open, -> { where("status = ?", 1) }
  scope :closed, -> { where("status = ?", 9) }
  scope :do_today, -> { open.where("will_start_at is null OR will_start_at < ?", Time.now) }
  scope :not_do_today, -> { open.where("will_start_at >= ?", Time.now) }

  belongs_to :project
  belongs_to :author, class_name: "User", foreign_key: :author_id
  belongs_to :assignee, class_name: "User", foreign_key: :assignee_id
  has_many :comments
  has_many :workloads

  validates :subject, presence: true

  def github
    IssueGithub.find_by(
      name: "github",
      provided_type: "Issue",
      foreign_id: self.id
    )
  end

  def add_github(number)
    issue_github = IssueGithub.find_or_create_by(
      name: "github",
      provided_type: "Issue",
      foreign_id: self.id
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
      foreign_id: self.id
    )
  end

  def add_ruffnote(number) #index
    issue_ruffnote = IssueRuffnote.find_or_create_by(
      name: "ruffnote",
      provided_type: "Issue",
      foreign_id: self.id
    )
    issue_ruffnote.number = number
    full_name = self.project.ruffnote.full_name
    issue_ruffnote.html_url = "https://ruffnote.com/#{full_name}/issues/#{number}"
    issue_ruffnote.save
  end

  def self.with_status(status)
    case status
    when "open"
      do_today
    when "closed"
      closed
    when "not_do_today"
      not_do_today
    end
  end

  def close
    update(status: 9, closed_on: Time.now.utc)
  end

  def reopen
    update(status: 1)
  end

  def do_today?
    return true if self.will_start_at.nil? || self.will_start_at < Time.now
    false
  end
end
