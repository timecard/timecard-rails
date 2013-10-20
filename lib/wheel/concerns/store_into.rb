require 'active_support/concern'

module Wheel
  module Concerns
    module StoreInto
      extend ActiveSupport::Concern

      included do
      end

      module ClassMethods
        attr_accessor :store_keys, :store_attributes
        class StoreAttrs < BasicObject
          attr_accessor :attrs
          def method_missing(name, *args)
            @attrs[name] = args[0]
          end
          def initialize
            @attrs = {}
          end
        end
        def store_into(name, &block)
          a = StoreAttrs.new
          a.instance_eval &block
          store name, :accessors => a.attrs.keys
          @store_keys = a.attrs.keys
          @store_attributes = a.attrs
        end
      end

    end
  end
end
