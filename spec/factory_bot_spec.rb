require 'spec_helper'
require 'factory_bot'

describe FactoryBot do
  let(:factory_name) { :user }
  let(:factories_list) { [factory_name] }
  let(:empty) { [] }
  subject(:register_factory) { described_class.register(factory_name) }

  after do
    described_class.delete_all
  end

  describe '::register' do
    it 'add factory to list of known factories' do
      expect { register_factory }.to(
        change { described_class.list }.from(empty).to(factories_list)
      )
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
    context 'empty factory bot' do
      it 'return empty list' do
        is_expected.to be_empty
      end
    end

    context 'after registered factory' do
      let(:factory_name) { :user }

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
  describe '::build'
end
