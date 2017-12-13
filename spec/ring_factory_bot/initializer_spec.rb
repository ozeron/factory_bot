require 'spec_helper'
require 'ring_factory_bot/initializer'

describe RingFactoryBot::Initializer do
  subject { initializer }

  let(:initialized_constant) { RingFactoryBotTest::ClassWithWriteAttr }
  let(:const_name) { initialized_constant.name.underscore }
  let(:initializer) { described_class.new(initialized_constant) }

  describe '::build' do
    subject(:builded) { described_class.build(const_name) }

    it 'will return instance of Initializer' do
      is_expected.to be_instance_of(described_class)
    end

    it 'will constantize const name' do
      expect(builded.const).to eq(initialized_constant)
    end

    context 'when const supplied as second argument' do
      subject(:builded) { described_class.build(const_name, second_const) }

      let(:second_const) { RingFactoryBotTest::EmptyClass }

      it 'will use second const' do
        expect(builded.const).to eq(second_const)
      end
    end

    context 'when can not classify name' do
      let(:const_name) { 'unknown_name' }

      it 'will thron name error' do
        expect { builded }.to raise_error(NameError)
      end
    end

    context 'when constant is not class' do
      let(:const_name) { 'ring_factory_bot_test' }

      it 'will thron name error' do
        expect { builded }.to raise_error(ArgumentError, /Class object/)
      end
    end
  end

  describe '#initialize' do
    it 'create instance' do
      is_expected.to be_instance_of(described_class)
    end

    it 'can return empty list attributes' do
      expect(initializer.attributes).to eq([])
    end

    it 'can return const' do
      expect(initializer.const).to eq(initialized_constant)
    end
  end

  describe '#respond_to?' do
    it 'return true for #attributes' do
      is_expected.to respond_to('attributes')
    end

    it 'return true for #const' do
      is_expected.to respond_to('const')
    end

    it 'return false for some generic attribute' do
      is_expected.not_to respond_to('some_attr')
    end
  end

  describe '#const' do
    subject { initializer.const }

    let(:initializer) { described_class.new(initialized_constant) }

    it 'return constant initialer was created with' do
      is_expected.to eq(initialized_constant)
    end
  end

  describe '#attributes' do
    subject(:attributes) { initializer.attributes }

    context 'when empty initializer' do
      it 'return empty list' do
        is_expected.to eq([])
      end
    end

    context 'when has attributes' do
      subject(:attribute_object) { attributes[0] }

      before do
        initializer.instance_eval do
          attribute 5
        end
      end

      it 'first array element be symbol' do
        expect(attribute_object[0]).to eq(:attribute)
      end

      it 'second array element be callable' do
        expect(attribute_object[1]).to be_respond_to(:call)
      end
    end
  end

  describe '#method_missing' do
    context 'when :attributes received' do
      it 'return attribures list' do
        expect(initializer.attributes).to be_instance_of(Array)
      end
    end

    context 'when :const received' do
      it 'return const' do
        expect(initializer.const).to eq(initialized_constant)
      end
    end

    context 'when class has attribute' do
      it 'remeber called method missing' do
        expect do
          initializer.instance_eval do
            attribute 5
          end
        end.to(change { initializer.attributes.size }.from(0).to(1))
      end
    end

    context 'when attribue as block received' do
      before do
        initializer.instance_eval do
          attribute { 10 }
        end
      end

      it 'remeber block' do
        expect(initializer.attributes[0][1].call).to eq(10)
      end
    end

    context 'when attribue as value received' do
      before do
        initializer.instance_eval do
          attribute 15
        end
      end

      it 'remeber value as block' do
        expect(initializer.attributes[0][1].call).to eq(15)
      end
    end

    context 'when no data supplied' do
      it 'raise ArgumentError' do
        expect do
          initializer.instance_eval do
            attribute
          end
        end.to(raise_error(ArgumentError, /block or default value/))
      end
    end

    context 'when class not have attribute' do
      it 'raise NoMethodError' do
        expect do
          initializer.instance_eval do
            no_attribute 5
          end
        end.to(raise_error(NameError, /undefined local/))
      end
    end
  end
end
