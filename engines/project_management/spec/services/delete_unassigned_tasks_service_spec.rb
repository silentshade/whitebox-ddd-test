require 'rails_helper'

RSpec.describe ProjectManagement::DeleteUnassignedTasksService do
  subject { described_class.call }

  it 'calls UnassignedTasksPastDayQuery' do
    expect(ProjectManagement::UnassignedTasksPastDayQuery).to receive(:call).and_call_original
  end

  context 'when tasks found' do
    let!(:tasks) { FactoryBot.create_list(:task, 2, created_at: Time.current - 25.hours) }

    it 'calls DeleteTasksCommand with found tasks' do
      expect(ProjectManagement::DeleteTasksCommand).to receive(:call).with(tasks: match_array(tasks)).and_call_original
    end
  end

  context 'when tasks not found' do
    it 'calls DeleteTasksCommand with found tasks' do
      expect(ProjectManagement::DeleteTasksCommand).to receive(:call).with(tasks: []).and_call_original
    end
  end

  after { subject }
end
