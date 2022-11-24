require 'rails_helper'

RSpec.describe ProjectManagement::ProjectShowPresenter do
  context 'when project argument passed' do
    let(:project) { FactoryBot.create(:project) }
    subject { described_class.new(project: project) }

    describe '#tasks' do
      it 'calls ProjectTasksQuery with project_id' do
        expect(ProjectManagement::ProjectTasksQuery).to receive(:call).with(project_id: project.id)
        subject.tasks
      end
    end

    describe '#available_users' do
      it 'calls UserAccess::AllUsersService' do
        expect_any_instance_of(UserAccess::AllUsersService).to receive(:call)
        subject.available_users
      end
    end

    describe '#presenter_for' do
      let(:available_users) { FactoryBot.create_list(:user, 2) }
      let(:task) { FactoryBot.create(:task, project_id: project.id) }
      it 'returns new TaskRowPresenter passing given task and #available_users' do
        allow_any_instance_of(described_class).to receive(:available_users).and_return(available_users)
        allow(ProjectManagement::TaskRowPresenter).to receive(:new).with(task: task, available_users: available_users)
      end
    end
  end

  context 'when project argument is not passed' do
    it 'raises ArgumentError' do
      expect { described_class.new }.to raise_error(ArgumentError)
    end
  end
end
