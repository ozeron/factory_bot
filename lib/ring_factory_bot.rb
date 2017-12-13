# frozen_string_literal: true
require 'active_support/core_ext/string/inflections.rb'
require 'ring_factory_bot/initializer'

module RingFactoryBot
  class <<self
    NO_OP = proc{}

    def list
      @factories&.keys || []
    end

    def register(name, &block)
      @factories ||= {}
      @classes || {}
      validate_no_dublicate!(name)
      validate_can_constantize!(name)
      @factories[name] = block || NO_OP
      # @classes[name] =
    end

    def delete_all
      @factories = {}
    end

    def validate_no_dublicate!(name)
      return unless @factories.key?(name)
      err_msg = 'you can register only one factory with this name'
      raise ArgumentError, err_msg
    end

    def validate_can_constantize!(name)
      constantize(name)
    end

    def constantize(name)
      name.to_s.classify.constantize
    end
  end
end
