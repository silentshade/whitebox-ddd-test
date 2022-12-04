require 'rails_helper'

RSpec.describe UserAccess::User do
  subject { FactoryBot.build :user }

  describe 'factory' do
    it { is_expected.to be_valid }
    it { is_expected.to have_attributes(first_name: 'John', last_name: 'Doe', identifier: an_uuid, password: '123456', email: a_string_matching(/example\d+@example.com/) )}
  end

  describe 'devise modules' do
    let(:devise_modules) do
      [Devise::Models::Validatable,
       Devise::Models::Registerable,
       Devise::Models::Rememberable,
       Devise::Models::DatabaseAuthenticatable,
       Devise::Models::Authenticatable]
    end
    it { expect(described_class.ancestors).to include(*devise_modules) }
  end
end
