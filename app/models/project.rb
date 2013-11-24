class Project < ActiveRecord::Base
  STATUS_ACTIVE   = 1
  STATUS_CLOSED   = 5
  STATUS_ARCHIVED = 9

  scope :active, -> { where(status: STATUS_ACTIVE) }
  scope :closed, -> { where(status: STATUS_CLOSED) }
  scope :archive, -> { where(status: STATUS_ARCHIVED) }
  scope :public, -> { where(is_public: true) }

  has_many :members, dependent: :destroy
  has_many :issues, dependent: :destroy

  validates :name, presence: true

  def admin?(user)
    member?(user) ? members.find_by("user_id = ?", user.id).is_admin : false
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

  def modify(params)
    if params[:github_full_name]
      self.add_github(params[:github_full_name])
      params.delete(:github_full_name)
    end
    if params[:ruffnote_full_name]
      self.add_ruffnote(params[:ruffnote_full_name])
      params.delete(:ruffnote_full_name)
    end
    self.update(params)
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

  def add_github(full_name)
    pg = ProjectGithub.find_or_create_by(
      name: "github",
      foreign_id: self.id,
      provided_type: "Project"
    )
    pg.full_name = full_name.gsub(/[[:space:]*]/, "")
    pg.save
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
end
