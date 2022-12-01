require 'rails_helper'

RSpec.describe ProjectManagement::DeleteUnassignedTasksService do
  subject { described_class.call }

  context 'when there are tasks without assignees' do
    let(:tasks_with_assignees) { FactoryBot.create_list(:task, 2) }
    let(:assignee_1) { FactoryBot.create(:assignee, task_id: tasks_with_assignees.first.id)}
    let(:assignee_2) { FactoryBot.create(:assignee, task_id: tasks_without_assignees.last.id) }
    let(:tasks_without_assignees) { FactoryBot.create_list(:task, 2) }
    let!(:deletable_task) { tasks_with_assignees.first }

    context 'when some of those tasks are created more then 24 hours ago' do
      before do
        deletable_task.update_columns created_at: Time.current - 30.hours
      end

      it 'deletes tasks created 24 hours ago' do
        expect { subject }.to change(ProjectManagement::Task, :count).by(-1)
        expect(ProjectManagement::Task.find_by(id: deletable_task.id)).to be_nil
      end

      it 'doesnt delete tasks created less then 24 hours ago' do
        subject
        expect(ProjectManagement::Task.where(id: [*tasks_with_assignees, *tasks_without_assignees].map(&:id)).count).to eq(3)
      end

      it 'doesnt delete tasks with assignees' do
        subject
        expect(ProjectManagement::Task.where(id: tasks_without_assignees.map(&:id)).count).to eq(2)
      end
    end

    context 'when all of those tasks are created less then 24 hours ago' do
      it 'doesnt delete any tasks' do
        subject
        expect(ProjectManagement::Task.where(id: [*tasks_with_assignees, *tasks_without_assignees].map(&:id)).count).to eq(4)
      end
    end
  end

  context 'when there are no tasks without assignees' do
    let(:tasks_without_assignees) { FactoryBot.create_list(:task, 2) }
    let!(:assignee_1) { FactoryBot.create(:assignee, task_id: tasks_without_assignees.first.id)}
    let!(:assignee_2) { FactoryBot.create(:assignee, task_id: tasks_without_assignees.last.id) }

    it 'doesnt delete any tasks' do
      expect(ProjectManagement::Task.where(id: tasks_without_assignees.map(&:id)).count).to eq(2)
    end
  end
end
