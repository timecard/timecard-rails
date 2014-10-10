class Authentication < ActiveRecord::Base
  belongs_to :user

  validates :username, presence: true

  def self.selectable_providers(user)
    res = {}
    providers = ["crowdworks"]
    active_providers = user.authentications.map{|a|a.provider}
    providers.each do |provider|
      unless active_providers.include?(provider)
        res[provider] = provider 
      end
    end
    return res
  end


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
