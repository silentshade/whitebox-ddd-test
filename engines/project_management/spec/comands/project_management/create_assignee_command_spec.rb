require 'rails_helper'

RSpec.describe ProjectManagement::CreateAssigneeCommand do
  subject { described_class }
  let(:user_identifier) { SecureRandom.uuid }
  let(:task_id) { FactoryBot.create(:task).id }
  let(:email) { 'example@example.com' }
  let(:options) { {user_identifier:, task_id:, email:} }

  context 'when all required attrs passed' do
    it 'returns success result' do
      expect(subject.call(**options)).to be_success
    end

    it 'creates assignee' do
      expect{ subject.call(**options) }.to change(ProjectManagement::Assignee, :count).by(1)
    end

    it 'sets correct attributes for created assignee' do
      result = subject.call(**options)
      expect(result.success.attributes.symbolize_keys).to include(**options)
    end
  end
end
