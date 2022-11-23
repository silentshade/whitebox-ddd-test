require 'rails_helper'

RSpec.describe ProjectManagement::ProjectTasksQuery do
  subject { described_class }
  let(:project) { FactoryBot.create(:project) }
  let(:project_id) { project.id }
  let(:tasks) { FactoryBot.create_list(:task, 2, project_id:) }

  context 'when there are tasks for given project_id' do
    it 'returns tasks for given project_id' do
      expect(subject.call(project_id:)).to eq(tasks)
    end

    context 'when task has assignees' do
      let(:task_id) { tasks.first.id }
      before { FactoryBot.create_list(:assignee, 2, task_id: )}

      it 'doesnt cause N+1 problem when accessing task.assignees' do
        tasks = subject.call(project_id:).to_a
        expect(->(){ tasks.each { |t| t.assignees.first } }).to not_talk_to_db
      end
    end
  end

  context 'when there are no tasks for given project_id' do
    it 'returns empty result' do
      expect(subject.call(project_id: 10)).to be_empty
    end
  end
end
