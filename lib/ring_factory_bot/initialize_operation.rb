# frozen_string_literal: true

module RingFactoryBot
  module InitializeOperation
    class <<self
      def build(initializer, **args)
        object = initializer.const.new
        initializer.attributes.each do |symbol, callable|
          set_attribute(object, symbol, callable.call)
        end

        args.each do |key, value|
          set_attribute(object, key, value)
        end

        object
      end

      private

      def set_attribute(object, symbol, value)
        object.public_send("#{symbol}=", value)
      end
    end
  end
end
