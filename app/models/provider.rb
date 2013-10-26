require 'active_support/concern'
require 'wheel/concerns/store_into'
class Provider < ActiveRecord::Base
  include Wheel::Concerns::StoreInto

  def self.github
    #TODO これだと複数人で運用している場合も同じ人のoauth_tokenが利用されてしまうので議論の余地あり
    # （実行者はgithubのoauthを持たないこと場合も想定される）
    # https://ruffnote.com/timecard/timecard/3412
    Github.new(
      :client_id => SERVICES['github']['key'],
      :client_secret => SERVICES['github']['secret'],
      :oauth_token => Authentication.find_by(
        "oauth_token is not null"
      ).oauth_token 
    )
  end
end
