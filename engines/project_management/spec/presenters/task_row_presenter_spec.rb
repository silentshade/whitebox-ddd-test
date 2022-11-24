require 'rails_helper'

RSpec.describe ProjectManagement::TaskRowPresenter do
  context 'when required arguments (task:, available_users:) passed' do
    let(:task) { FactoryBot.create(:task) }
    let(:available_users) { FactoryBot.create_list(:user, 3) }
    subject { described_class.new(task:, available_users:) }

    describe '#users' do
      context 'when one of available users already added as assignee' do
        before { FactoryBot.create(:assignee, task_id: task.id, user_identifier: available_users.first.identifier) }

        it 'returns only not added users' do
          expect(subject.users).to eq(available_users[1..-1])
        end
      end

      context 'when all users are available for assignment' do
        it 'returns all available users' do
          expect(subject.users).to eq(available_users)
        end
      end
    end
  end

end
