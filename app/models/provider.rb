require 'active_support/concern'
require 'wheel/concerns/store_into'
class Provider < ActiveRecord::Base
  include Wheel::Concerns::StoreInto

  def self.github(token)
    Github.new(
      :client_id => SERVICES['github']['key'],
      :client_secret => SERVICES['github']['secret'],
      :oauth_token => token
    )
  end
end
