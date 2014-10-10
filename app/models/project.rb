class Project < ActiveRecord::Base
  STATUS_ACTIVE   = 1
  STATUS_CLOSED   = 5

  scope :active, -> { where(status: STATUS_ACTIVE) }
  scope :closed, -> { where(status: STATUS_CLOSED) }
  scope :published, -> { where(is_public: true) }
  scope :visible, -> (user) { where(id: Member.where(user_id: user.id).pluck(:project_id)) }

  has_many :members, dependent: :destroy
  has_many :issues, dependent: :destroy
  has_many :crowdworks_contracts

  validates :name, presence: true

  def admin?(user)
    member?(user) ? members.find_by("user_id = ?", user.id).is_admin : false
  end

  def admin
    members.find_by(is_admin: true).user
  end

  def member?(user)
    members.exists?(["user_id = ?", user.id]) ? true : false
  end

  def providers
    Provider.where(
      provided_type: "Project",
      foreign_id: self.id
    ).map do |p|
      if p.name == "github"
        ProjectGithub.find(p.id) #FIXME
      end
    end
  end

  def update(params)
    if params[:github_full_name]
      if self.add_github(params[:github_full_name])
        params.delete(:github_full_name)
      else
        return false
      end
    end
    if params[:ruffnote_full_name]
      self.add_ruffnote(params[:ruffnote_full_name])
      params.delete(:ruffnote_full_name)
    end
    super(params)
  end

  def github_full_name
    self.github ? self.github.full_name : nil
  end

  def github
    ProjectGithub.find_by(
      name: "github",
      provided_type: "Project",
      foreign_id: self.id
    )
  end

  def add_github(full_name, validate = true)
    pg = ProjectGithub.find_or_create_by(
        name: "github",
        foreign_id: self.id,
        provided_type: "Project"
    )

    if validate
      admin = User.find(self.members.find_by("is_admin = true").user_id)
      github = Github.new(oauth_token: admin.github.oauth_token)
      owner, repo_name = full_name.gsub(/[[:space:]*]/, "").split("/")
      repo = github.repos.get(owner, repo_name)
      return false unless repo
    end

    pg.full_name = full_name.gsub(/[[:space:]*]/, "")
    pg.save
  rescue Github::Error::NotFound => e
    self.errors.add(:base, "#{full_name} is not found.")
    false
  rescue ArgumentError => e
    self.errors.add(:base, "#{full_name} is invalid. Please confirm input parameters.")
    false
  rescue => e
    logger.debug "[ERROR] #{e.class} #{e.message}"
    self.errors.add(:base, "An unexpected error has occurred. Please confirm input parameters.")
    false
  end

  def ruffnote_full_name
    self.ruffnote ? self.ruffnote.full_name : nil
  end

  def ruffnote
    ProjectRuffnote.find_by(
      name: "ruffnote",
      provided_type: "Project",
      foreign_id: self.id
    )
  end

  def add_ruffnote(full_name)
    pr = ProjectRuffnote.find_or_create_by(
      name: "ruffnote",
      foreign_id: self.id,
      provided_type: "Project"
    )
    pr.full_name = full_name
    pr.save
  end

  def active?
    self.status == Project::STATUS_ACTIVE
  end

  def closed?
    self.status == Project::STATUS_CLOSED
  end

  def self.status(status)
    case status.to_i
    when Project::STATUS_ACTIVE
      self.active
    when Project::STATUS_CLOSED
      self.closed
    end
  end

  def visible?(user)
    return true if user.id == 1
    return true if self.is_public
    return true if self.members.exists?(["user_id = ?", user.id])
    false
  end

  def github_members(token)
    github = Github.new(oauth_token: token)
    owner, repo = self.github.full_name.split("/")
    cbrs = github.repos.collaborators.list(owner, repo)

    members.where(
      user_id: Authentication.where(
        provider: "github", uid: cbrs.map {|c| c.id }
      ).pluck(:user_id)
    )
  rescue => e
    logger.debug e.message
  end

  def users
    members.map { |m| m.user }
  end

  def time_entries
    Workload.where(issue_id: issues.ids)
  end

  def comments
    Comment.where(issue_id: issues.ids)
  end

  def github_issues
    IssueGithub.where(foreign_id: issues.ids)
  end

  def crowdworks_contract_id_by(user)
    crowdworks_contracts.find_by(user: user).contract_id
  end
end
