require 'rails_helper'

RSpec.describe ProjectManagement::TaskByIdQuery do
  subject { described_class }

  context 'when task exists for given task_id' do
    let(:task) { FactoryBot.create(:task) }
    let(:task_id) { task.id }
    let(:result) { subject.call(task_id:) }

    it 'returns success with found task' do
      expect(result).to be_success
      expect(result.success).to eq(task)
    end
  end

  context 'when task doesnt exists for given task_id' do
    let(:result) { subject.call(task_id: 10) }
    it 'returns success with "Task not found" message' do
      expect(result).to be_failure
      expect(result.failure).to eq('Task not found')
    end
  end
end
