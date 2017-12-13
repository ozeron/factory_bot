require 'spec_helper'
require 'ring_factory_bot/initializer'

describe RingFactoryBot::Initializer do
  let(:initialized_constant) { RingFactoryBotTest::ClassWithAttr }
  let(:initializer) { described_class.new(initialized_constant) }

  describe '#initialize' do
    subject { initializer }

    it 'create instance' do
      is_expected.to be_instance_of(described_class)
    end
  end

  describe '#const' do
    subject { initializer.const }

    let(:const) { RingFactoryBotTest }
    let(:initializer) { described_class.new(const) }

    it 'return constant initialer was created with' do
      is_expected.to eq(const)
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

    context 'when class not have attribute' do
      it 'raise NoMethodError' do
        expect do
          initializer.instance_eval do
            no_attribute 5
          end
        end.to(raise_error(NoMethodError))
      end
    end
  end
end
