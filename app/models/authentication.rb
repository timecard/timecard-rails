class Authentication < ActiveRecord::Base
  belongs_to :user

  def self.add_chatwork token
    a = Authentication.find_or_create_by(
      user_id: 1,
      provider: "chatwork",
    )
    a.oauth_token = token
    a.save
  end

  def self.get_chatwork_token
    Authentication.find_by(
      provider: "chatwork",
    ).oauth_token
  end
end
