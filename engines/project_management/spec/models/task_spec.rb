require 'rails_helper'

RSpec.describe ProjectManagement::Task do
  subject { FactoryBot.build :task }

  describe 'factory' do
    it { is_expected.to be_valid }
    it { is_expected.to have_attributes(title: 'Task', description: 'Description', project_id: Integer, identifier: a_string_matching(/TA-\d{4}/)) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_with(ProjectManagement::IdentifierValidator) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:assignees) }
  end
end
