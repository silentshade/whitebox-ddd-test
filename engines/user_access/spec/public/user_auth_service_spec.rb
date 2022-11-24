require 'rails_helper'

RSpec.describe UserAccess::UserAuthService do
  subject { described_class }
  let(:warden) { spy('warden') }

  describe '#call' do
    it 'calls warden.authenticate in user scope' do
      expect(warden).to receive(:authenticate!).with(scope: :user)
      subject.new(warden).call
    end
  end

  describe '#current_user_identifier' do
    context 'when warden returns user' do
      let(:user) { FactoryBot.create(:user) }
      before { allow(warden).to receive(:authenticate).with(scope: :user).and_return(user) }

      it 'returns user identifier' do
        expect(subject.new(warden).current_user_identifier).to eq(user.identifier)
      end
    end
  end
end
