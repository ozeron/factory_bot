# frozen_string_literal: true

module RingFactoryBot
  class Initializer
    ATTRIBUTES = %I[const attributes].freeze
    NO_OP = proc{}

    def self.build(name, const = nil, &block)
      initializer = new(const || name.to_s.classify.constantize)
      initializer.instance_eval(&block || NO_OP)
      initializer
    end

    def initialize(const)
      @const = const
      @attributes = []
    end

    def method_missing(symbol, *args, &block)
      if return_instance_variable?(symbol, *args, &block)
        return instance_variable_get("@#{symbol.to_s}")
      end

      if const_has_setter?(symbol)
        remember_step(symbol, *args, &block)
        return
      end

      super(symbol, *args, &block)
    end

    private

    def return_instance_variable?(symbol, *args, &block)
      ATTRIBUTES.include?(symbol) && args.empty? && block.nil?
    end

    def const_has_setter?(symbol)
      @const.instance_methods.include?("#{symbol}=".to_sym)
    end

    def remember_step(symbol, *args, &block)
      validate_step_arguments!(*args, &block)
      @attributes.push([symbol, wrap_args_to_block(*args, &block)])
    end

    def wrap_args_to_block(*args, &block)
      return block unless block.nil?
      proc { args.fetch(0) }
    end

    def validate_step_arguments!(*args, &block)
      return if !args.nil? || !block.nil?
      error_message = 'You should provide block or default value'
      raise ArgumentError, error_message
    end
  end
end
