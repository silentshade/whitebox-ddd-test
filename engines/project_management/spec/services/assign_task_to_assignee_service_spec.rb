# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectManagement::AssignTaskToAssigneeService do
  include Dry::Monads[:result]

  subject { described_class }
  let(:user_entity) { Class.new(Struct.new(:identifier)).new(SecureRandom.uuid) }
  let(:user_identifier) { user_entity.identifier }
  let(:current_user_identifier) { SecureRandom.uuid }
  let(:email) { 'example@example.com' }
  let(:task) { FactoryBot.create(:task) }
  let(:task_id) { task.id }
  let(:options) { {task_id:, current_user_identifier:, user_email: email} }

  before do
    allow(UserAccess::FetchByEmailService).to receive(:call).with(email:).and_return(user_entity)
    allow(ProjectManagement::TaskByIdQuery).to receive(:call).with(task_id:).and_return(Success(task))
    allow(ProjectManagement::AssigneeExistsQuery).to receive(:call).with(task_id:, user_identifier:).and_return(Success())
    allow(ProjectManagement::CreateAssigneeCommand).to receive(:call).with(user_identifier:, task_id:, email: ).and_return(Success())
  end

  context 'when all checks pass' do
    it 'returns success' do
      expect(subject.call(**options)).to be_success
    end
  end

  context 'when UserAccess::FetchByEmailService returns nil' do
    before do
      allow(UserAccess::FetchByEmailService).to receive(:call).with(email:).and_return(nil)
    end

    it 'returns failure' do
      result = subject.call(**options)
      expect(result).to be_failure
      expect(result.failure).to eq 'User not found'
    end
  end

  context 'when any service with monad return value returns failure' do
    let(:result) { subject.call(**options) }

    SERVICES = [ProjectManagement::TaskByIdQuery,
                ProjectManagement::AssigneeExistsQuery,
                ProjectManagement::CreateAssigneeCommand]

    SERVICES.each do |service|
      before do
        allow(service).to receive(:call).and_return(Failure('some failure'))
      end

      it 'returns failure' do
        expect(result).to be_failure
        expect(result.failure).to eq 'some failure'
      end
    end
  end

  describe 'sending notification' do
    context 'when instrumentation done' do
      let(:event_name) { 'project_management_domain_event.task_assigned' }
      let(:payload) { {assignee_identifier: user_identifier, assigner_identifier: current_user_identifier, task_identifier: task.identifier } }
      before { expect(ActiveSupport::Notifications).to receive(:instrument).with(event_name, payload).and_call_original }

      it 'calls ActiveSupport::Notifications.instrument with correct args' do
        expect(subject.call(**options)).to be_success
      end
    end

    context 'when instrumentation raised unexpected error' do
      before { allow(ActiveSupport::Notifications).to receive(:instrument).and_raise('Weird error') }

      it 'returns Failure("Weird error")' do
        expect(subject.call(**options)).to be_failure
        expect(subject.call(**options).failure).to eq('Weird error')
      end
    end
  end
end
