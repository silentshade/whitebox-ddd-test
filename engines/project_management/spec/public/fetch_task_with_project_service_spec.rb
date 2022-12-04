require 'rails_helper'

RSpec.describe ProjectManagement::FetchTaskWithProjectService do
  include Dry::Monads[:result]

  subject { described_class.call(identifier:) }
  let(:identifier) { 'TA-0100' }

  context 'when TaskByIdentifierQuery returns Success(task) for given identifier' do
    let(:task) { FactoryBot.create(:task, identifier: identifier) }
    before { allow(ProjectManagement::TaskByIdentifierQuery).to receive(:call).and_return(Success(task)) }

    context 'when ProjectByIdQuery returns Success(project) for task.project_id' do
      let(:project) { FactoryBot.create(:project) }
      before { allow(task).to receive(:project_id).and_return(project.id) }

      it 'returns success with {task:, project:} hash' do
        expect(subject).to be_success
        expect(subject.success).to eq({task:, project:})
      end
    end

    context 'when ProjectByIdQuery returns Failure("some message") for task.project_id' do
      before { allow(ProjectManagement::ProjectByIdQuery).to receive(:call).and_return(Failure('some message'))}
      it 'forwards ProjectByIdQuery failure' do
        expect(subject).to be_failure
        expect(subject.failure).to eq('some message')
      end
    end
  end

  context 'when task not found' do
    before { allow(ProjectManagement::TaskByIdentifierQuery).to receive(:call).and_return(Failure('some message'))}
    it 'forwards TaskByIdentifierQuery failure' do
      expect(subject).to be_failure
      expect(subject.failure).to eq('some message')
    end
  end
end
