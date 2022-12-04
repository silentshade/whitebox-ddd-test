# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectManagement::TaskByIdentifierQuery do
  subject { described_class }

  context 'when task exists for given task_id' do
    let(:task) { FactoryBot.create(:task) }
    let(:identifier) { task.identifier }
    let(:result) { subject.call(identifier:) }

    it 'returns success with found task' do
      expect(result).to be_success
      expect(result.success).to eq(task)
    end
  end

  context 'when task doesnt exists for given task_id' do
    let(:result) { subject.call(identifier: 'TA-100') }
    it 'returns failure with "Task not found" message' do
      expect(result).to be_failure
      expect(result.failure).to eq('Task not found')
    end
  end
end
