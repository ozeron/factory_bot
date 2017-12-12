# frozen_string_literal: true

class FactoryBot
  class <<self
    def list
      @factories&.keys || []
    end

    def register(name, &block)
      @factories ||= {}
      if @factories.key?(name)
        err_msg = 'you can register only one factory with this name'
        raise ArgumentError, err_msg
      end
      @factories[name] = block
    end

    def delete_all
      @factories = {}
    end
  end
end
