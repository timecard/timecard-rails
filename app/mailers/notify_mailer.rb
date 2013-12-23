class NotifyMailer < ActionMailer::Base
  default from: 'notify@timecard-rails.herokuapp.com'

  def sign_up_user(user)
    # FIXME Admin is not only user id = 1 user.
    @admin = User.find(1)
    @user = user
    mail(to: @admin.email, subject: "Sign up a new user!")
  end
end
