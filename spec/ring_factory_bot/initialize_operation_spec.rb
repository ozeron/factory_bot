require 'spec_helper'
require 'ring_factory_bot/initialize_operation'

describe RingFactoryBot::InitializeOperation do
  describe '::build' do
    subject(:builded) { described_class.build(initializer) }

    let(:initialized_constant) { RingFactoryBotTest::ClassWithAttr }
    let(:initializer) { RingFactoryBot::Initializer.new(initialized_constant) }

    before do
      initializer.instance_eval do
        attribute 145
      end
    end

    it 'return constant build by initializer' do
      is_expected.to be_instance_of(initialized_constant)
    end

    it 'return constant with initialized attributes' do
      expect(builded.attribute).to eq(145)
    end

    context 'with keyword arguments' do
      subject(:builded) do
        described_class.build(initializer, attribute: new_value)
      end

      let(:new_value) { 666 }

      it 'override block values' do
        expect(builded.attribute).to eq(666)
      end
    end

    context 'block shares index' do
      #FIXME: implement test and functionality
    end

    context 'with unsupported keyword arguments' do
      subject(:builded) do
        described_class.build(initializer, unsupported_attribute: new_value)
      end

      let(:new_value) { 666 }

      it 'throw NoMethodError' do
        expect { builded }.to raise_error(NoMethodError)
      end
    end
  end
end
