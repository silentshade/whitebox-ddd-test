require 'rails_helper'

RSpec.describe UserAccess::UserRegistrationService do
  subject { described_class.new(user_params).call }
  let(:user_params) { {email: 'existing@existing.com', first_name: 'John', last_name: 'Doe', password: '123456' }}

  context 'when user exists with given email' do
    before { FactoryBot.create :user, **user_params }
    it { is_expected.not_to be_success }
  end

  context 'when user doesnt exist with given email' do
    it { is_expected.to be_success }

    it 'creates user with given attributes' do
      expect do
        expect(subject.user.attributes.symbolize_keys).to include(user_params.except(:password))
      end.to change(UserAccess::User, :count).by(1)
    end

    it 'generates identifier for user' do
      expect(subject.user.identifier).not_to be_blank
    end
  end
end
