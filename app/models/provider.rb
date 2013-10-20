require 'active_support/concern'
require 'wheel/concerns/store_into'
class Provider < ActiveRecord::Base
  include Wheel::Concerns::StoreInto

  def self.github
    Github.new(
      :client_id => SERVICES['github']['key'],
      :client_secret => SERVICES['github']['secret'],
      :oauth_token => Authentication.where(
        "oauth_token is not null"
      ).first.oauth_token #TODO
    )
  end
end
