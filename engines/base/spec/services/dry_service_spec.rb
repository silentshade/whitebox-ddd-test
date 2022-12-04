require 'rails_helper'

RSpec.describe DryService do

  context 'when inherited' do
    subject { Class.new(described_class) }

    it 'includes Dry::Monads::Do' do
      expect(subject.new).to be_kind_of Dry::Monads::Do::All
    end

    it 'includes Dry::Monads::Result' do
      expect(subject.new).to be_kind_of Dry::Monads::Result::Mixin
    end

    it 'includes Dry::Initializer' do
      expect(subject.new).to be_kind_of Dry::Initializer::Mixin::Root
    end

    describe 'arguments checking' do
      before do
        subject.class_eval do
          param :valid_param
          option :valid_option

          def call; end
        end
      end

      context 'when required arguments not passed' do
        let(:inst) { subject.call }
        it 'raises argument error' do
          expect { inst }.to raise_error(ArgumentError)
        end
      end

      context 'when required arguments passed' do
        let(:inst) { subject.call(:valid_param, valid_option: :valid_option) }
        it 'raises argument error' do
          expect { inst }.not_to raise_error
        end
      end
    end

  end
end
