require 'rails_helper'

RSpec.describe ProjectManagement::Assignee do
  subject { FactoryBot.build :assignee }

  describe 'factory' do
    it { is_expected.to be_valid }
    it { is_expected.to have_attributes(task_id: 100, email: 'example@example.com', user_identifier: an_uuid) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user_identifier) }
    it { is_expected.to allow_values(*%w(example@example.com example+1@example.com)).for(:email) }
    it { is_expected.not_to allow_values('example', '@example@example.com', 'ex ample@example.com').for(:email) }
  end
end
