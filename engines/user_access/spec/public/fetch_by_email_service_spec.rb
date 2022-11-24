require 'rails_helper'

RSpec.describe UserAccess::FetchByEmailService do
  subject { described_class.new(email: email).call }
  let(:email) { 'existing@example.com' }

  context 'when user with given email exists' do
    let!(:user) { FactoryBot.create(:user, email:) }
    it { is_expected.to eq(user) }
  end

  context 'when user with given email doesnt exist' do
    it { is_expected.to be_nil }
  end
end
