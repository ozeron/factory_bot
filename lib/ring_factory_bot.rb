# frozen_string_literal: true
require 'active_support/core_ext/string/inflections.rb'
require_relative 'ring_factory_bot/initializer'
require_relative 'ring_factory_bot/initialize_operation'

module RingFactoryBot
  class <<self
    def list
      @factories&.keys || []
    end

    def register(name, const = nil, &block)
      @factories ||= {}
      @classes || {}
      validate_no_dublicate!(name)
      @factories[name.to_s] = Initializer.build(name, const, &block)
    end

    def build(name, **args)
      InitializeOperation.build(@factories.fetch(name.to_s), **args)
    rescue KeyError
      msg = "Factory '#{name}' not defined, use #register to add it"
      raise NameError, msg
    end

    def delete_all
      @factories = {}
    end

    private

    def validate_no_dublicate!(name)
      return unless @factories.key?(name)
      err_msg = 'you can register only one factory with this name'
      raise ArgumentError, err_msg
    end
  end
end
