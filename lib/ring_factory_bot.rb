# frozen_string_literal: true
require 'active_support/core_ext/string/inflections.rb'
require 'ring_factory_bot/initializer'

module RingFactoryBot
  class <<self
    def list
      @factories&.keys || []
    end

    def register(name, const = nil, &block)
      @factories ||= {}
      @classes || {}
      validate_no_dublicate!(name)
      validate_can_constantize!(name) if const.nil?
      @factories[name] = Initializer.build(name, const, &block)
    end

    def build(name, **args)
      InitializeOperation.build(@factories.fetch(name), **args)
    rescue KeyError
      msg = "Factory '#{name}' not defined, use #register to add it"
      raise_error NameError, msg
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
      name.to_s.classify.constantize
    end
  end
end
