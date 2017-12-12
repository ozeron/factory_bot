# frozen_string_literal: true

require 'spec_helper'
require 'factory_bot'

describe FactoryBot do
  subject(:register_factory) { described_class.register(factory_name) }

  let(:factory_class) { RingFactoryBotTest::EmptyClass }
  let(:factory_name) { 'ring_factory_bot_test/empty_class' }
  let(:factories_list) { [factory_name] }
  let(:empty) { [] }

  after do
    described_class.delete_all
  end

  describe '::register' do
    it 'add factory to list of known factories' do
      expect { register_factory }.to(
        change { described_class.list }.from(empty).to(factories_list)
      )
    end

    context 'when no block passed with name' do
      it 'works fine' do
        expect { register_factory }.not_to raise_error
      end
    end

    context 'when can not find constant' do
      it 'raise argument error' do
        expect { described_class.register(:not_existed_class) }.to(
          raise_error(NameError)
        )
      end
    end

    context 'when factory with same name exist' do
      before do
        register_factory
      end

      it 'throw error' do
        expect { described_class.register(factory_name) }.to(
          raise_error(ArgumentError)
        )
      end
    end
  end

  describe '::list' do
    subject { described_class.list }

    context 'with empty factory bot' do
      it 'return empty list' do
        is_expected.to be_empty
      end
    end

    context 'with registered factory' do
      before do
        described_class.register(factory_name)
      end

      it 'return factory name in list' do
        is_expected.to eq(factories_list)
      end
    end
  end

  describe '::delete_all' do
    before do
      register_factory
    end

    it 'clear list of factories' do
      expect { described_class.delete_all }.to(
        change { described_class.list }.from(factories_list).to(empty)
      )
    end
  end

  describe '::build' do
    subject(:build) { described_class.build(factory_name) }

    it 'return instance of expected constant' do
      is_expected.to be_instance_of(factory_class)
    end

    context 'when factory not defined' do
      let(:factory_name) { :any_other_class }

      it 'return instance of expected constant' do
        expect { build }.to raise_error(NameError)
      end
    end
  end
end
