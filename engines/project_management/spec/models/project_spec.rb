require 'rails_helper'

RSpec.describe ProjectManagement::Project do
  subject { FactoryBot.build :project }

  describe 'factory' do
    it { is_expected.to be_valid }
    it { is_expected.to have_attributes(title: 'Title', description: 'Description', user_identifier: an_uuid, identifier: a_string_matching(/PR-\d{4}/)) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:user_identifier) }
    it { is_expected.to validate_with(ProjectManagement::IdentifierValidator) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:tasks) }
  end
end
