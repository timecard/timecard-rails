class Member < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  def admin?
    role == 0
  end

  def moderator?
    role == 1
  end
end
