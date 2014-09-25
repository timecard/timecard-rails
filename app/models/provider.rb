require 'active_support/concern'
require 'wheel/concerns/store_into'
class Provider < ActiveRecord::Base
  include Wheel::Concerns::StoreInto

  def self.github(token)
    Github.new(
      :client_id => Settings.services.github.client_id,
      :client_secret => Settings.services.github.client_secret,
      :oauth_token => token
    )
  end

=begin
  def self.ruffnote(token)
    Ruffnote.new(
      :client_id => SERVICES['ruffnote']['key'],
      :client_secret => SERVICES['ruffnote']['secret'],
      :oauth_token => token
    )
  end
=end

  def self.ruffnote(token)
    client = OAuth2::Client.new(
      Settings.services.ruffnote.key,
      Settings.services.ruffnote.secret,
      site: Settings.services.ruffnote.url
    )
    return OAuth2::AccessToken.new(client, token)
  end
end
