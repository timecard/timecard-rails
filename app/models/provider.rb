require 'active_support/concern'
require 'wheel/concerns/store_into'
class Provider < ActiveRecord::Base
  include Wheel::Concerns::StoreInto
end
