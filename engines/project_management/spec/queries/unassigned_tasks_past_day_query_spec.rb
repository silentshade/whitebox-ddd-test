require 'rails_helper'

RSpec.describe ProjectManagement::UnassignedTasksPastDayQuery do
  context 'when there are unassigned tasks' do
    let(:tasks_with_assignees) { FactoryBot.create_list(:task, 2) }
    let!(:assignee_1) { FactoryBot.create(:assignee, task_id: tasks_with_assignees.first.id)}
    let!(:assignee_2) { FactoryBot.create(:assignee, task_id: tasks_with_assignees.last.id) }
    let(:tasks_without_assignees) { FactoryBot.create_list(:task, 2) }

    context 'when some of them created more then a day ago' do
      before do
        tasks_with_assignees.first.update_columns created_at: Time.current - 30.hours
        tasks_without_assignees.first.update_columns created_at: Time.current - 30.hours
      end

      it 'returns only unassigned tasks older then one day' do
        expect(described_class.call.to_a).to eq([tasks_without_assignees.first])
      end
    end
  end
end
