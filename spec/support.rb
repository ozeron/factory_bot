# frozen_string_literal: true

# define simple class to test const search
module RingFactoryBotTest
  class EmptyClass
  end

  class ClassWithAttr
    attr_accessor :attribute
  end

  class ClassWithWriteAttr
    attr_writer :attribute
  end
end
