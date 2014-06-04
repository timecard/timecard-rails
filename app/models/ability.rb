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
    end
  end

  def authorize_project(user)
    can :read, Project do |project|
      project.visible?(user)
    end
    can :create, Project do |project|
      user.persisted? # logged in user
    end
    can [:update, :close, :active], Project do |project|
      project.admin?(user)
    end
    cannot :destroy, Project
  end

  def authorize_issue(user)
    can :read, Issue do |issue|
      issue.project.visible?(user)
    end
    can [:create, :update, :reopen, :close], Issue do |issue|
      issue.project.member?(user)
    end
  end

  def authorize_comment(user)
    can :update, Comment do |comment|
      comment.issue.project.member?(user)
    end
  end

  def authorize_workload(user)
    can [:read, :update, :destroy], Workload do |workload|
      workload.issue.project.admin?(user) ||
        (workload.issue.project.member?(user) && workload.user_id == user.id)
    end

    can [:start, :stop], Workload do |workload|
      workload.issue.project.admin?(user) ||
        workload.issue.project.member?(user)
    end
  end
end
