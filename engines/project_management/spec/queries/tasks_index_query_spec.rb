require 'rails_helper'

RSpec.describe ProjectManagement::TasksIndexQuery do
  subject { described_class }
  let(:user_identifier) { SecureRandom.uuid }
  let(:tasks) { FactoryBot.create_list(:task, 2) }
  before do
    tasks.each { |t| FactoryBot.create(:assignee, user_identifier:, task_id: t.id) }
  end

  context 'when there are tasks assigned to users with given user_identifier' do
    it 'returns tasks for given user identifier_identifier' do
      expect(subject.call(user_identifier:)).to eq(tasks)
    end
  end

  context 'when there are no tasks with assignees for given user_identifier' do
    it 'returns empty result' do
      expect(subject.call(user_identifier: SecureRandom.uuid)).to be_empty
    end
  end
end
