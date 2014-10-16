class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # for Guest User (not logged in)
    if user.id == 1
      # System Administrator
      can :manage, :all
    else
      authorize_project(user)
      authorize_issue(user)
      authorize_comment(user)
      authorize_workload(user)
      authorize_user(user)
      authorize_member(user)
    end
  end

  def authorize_project(user)
    can :read, Project do |project|
      project.visible?(user)
    end
    can :create, Project do |project|
      user.persisted? # logged in user
    end
    can [:update, :close, :active, :report], Project do |project|
      member = project.members.find_by(user_id: user.id)
      member && (member.admin? || member.moderator?)
    end
    cannot :destroy, Project
  end

  def authorize_issue(user)
    can :read, Issue do |issue|
      issue.project.visible?(user)
    end
    can [:create, :update, :reopen, :close], Issue do |issue|
      issue.project.member?(user) && issue.project.active?
    end
  end

  def authorize_comment(user)
    can [:update, :destroy], Comment do |comment|
      user == comment.user
    end
  end

  def authorize_workload(user)
    can [:read, :create, :update, :destroy, :stop], Workload do |workload|
      user == workload.user && workload.issue.project.active?
    end
  end

  def authorize_user(current_user)
    can :report, User do |user|
      current_user == user
    end
  end

  def authorize_member(user)
    can [:update, :destroy], Member do |member|
      member = user.members.find_by(project_id: member.project.id)
      member && (member.admin? || member.moderator?)
    end
  end
end
