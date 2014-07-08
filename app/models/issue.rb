class Issue < ActiveRecord::Base
  include PublicActivity::Model

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

  after_create :track_create_activity
  before_update :track_update_status_activity

  def github
    IssueGithub.find_by(
      name: "github",
      provided_type: "Issue",
      foreign_id: self.id
    )
  end

  def add_github(issue)
    issue_github = IssueGithub.find_or_create_by(
      name: "github",
      provided_type: "Issue",
      foreign_id: self.id
    )
    issue_github.number = issue.number
    issue_github.html_url = issue.html_url
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
    issue_ruffnote.html_url = "#{SERVICES['ruffnote']['url']}/#{full_name}/issues/#{number}"
    issue_ruffnote.save
  end

  def provider
    return github if github
    return ruffnote if ruffnote
    nil
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

  private

  def track_create_activity
    self.create_activity(:create, owner: self.author, recipient: self.project)
  end

  def track_update_status_activity
    if self.changes.has_key?("status")
      if self.changes["status"][1] == 1
        self.create_activity(:reopen, owner: User.current, recipient: self.project)
      else
        self.create_activity(:close, owner: User.current, recipient: self.project)
      end
    end
  end
end
