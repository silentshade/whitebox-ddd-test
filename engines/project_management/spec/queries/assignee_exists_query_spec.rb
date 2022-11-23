require 'rails_helper'

RSpec.describe ProjectManagement::AssigneeExistsQuery do
  subject { described_class }
  let(:task_id) { FactoryBot.create(:task).id }
  let(:user_identifier) { SecureRandom.uuid }

  context 'when assignee exists for given task_id and user identifier' do
    before { FactoryBot.create :assignee, task_id:, user_identifier: }

    it 'returns failure' do
      expect(subject.call(task_id:, user_identifier:)).to be_failure
    end
  end

  context 'when assignee doesnt exist for given user_identifier' do
    it 'returns success' do
      expect(subject.call(task_id:, user_identifier: SecureRandom.uuid)).to be_success
    end
  end

  context 'when assignee doesnt exist for given task_id' do
    it 'returns success' do
      expect(subject.call(task_id: 10, user_identifier:)).to be_success
    end
  end
end
