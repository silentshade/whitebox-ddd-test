require 'rails_helper'

RSpec.describe Notifications::AssigneeNotificationService do
  include Dry::Monads[:result]
  subject { described_class.call(payload:) }

  context 'when payload contains all required fields' do
    let(:payload) { { assignee_identifier: SecureRandom.uuid, assigner_identifier: SecureRandom.uuid, task_identifier: SecureRandom.uuid }}

    it 'calls UserAccess::FetchByIdentifiersService with assignee identifier and user assigner identifier' do
      expect(UserAccess::FetchByIdentifiersService).to receive(:call)
                                                         .with(identifiers: payload.fetch_values(:assignee_identifier, :assigner_identifier))
                                                         .and_call_original
      subject
    end

    context 'when assignee and assigner found' do
      let(:assignee) { FactoryBot.create(:user) }
      let(:assigner) { FactoryBot.create(:user) }
      before do
        allow(UserAccess::FetchByIdentifiersService).to receive(:call).and_return([assignee, assigner])
      end

      it 'calls ProjectManagement::FetchTaskWithProjectService with task identifier' do
        expect(ProjectManagement::FetchTaskWithProjectService).to receive(:call)
                                                                    .with(identifier: payload.fetch(:task_identifier))
                                                                    .and_call_original
        subject
      end

      context 'when task and project found' do
        let(:project) { FactoryBot.create(:project) }
        let(:task) { FactoryBot.create(:task, project_id: project.id) }
        let(:message) do
          <<~STR.strip
            Hello #{assignee.first_name} #{assignee.last_name},
            #{assigner.first_name} #{assigner.last_name} assigned a task "#{task.title}" for you
            in project "#{project.title}"
          STR
        end
        before { allow(ProjectManagement::FetchTaskWithProjectService).to receive(:call).and_return(Success({task:, project:}))}
        before { ActiveJob::Base.queue_adapter = :test }

        it 'composes message and calls mailer' do
          expect(Notifications::TaskMailer).to receive(:task_assigned).with(email: assignee.email, message:).and_call_original
          subject
        end

        it 'enqueues mailer job' do
          expect { subject }.to have_enqueued_job(ActionMailer::MailDeliveryJob).with("Notifications::TaskMailer",
                                                                                      "task_assigned",
                                                                                      "deliver_now",
                                                                                      { args: [{email: assignee.email, message: }]})
        end

        it 'returns success' do
          expect(subject).to be_success
        end

        context 'when Notifications::TaskMailer returns exception' do
          before { allow_any_instance_of(ActionMailer::MailDeliveryJob).to receive(:successfully_enqueued?).and_return(false) }
          it 'forwards returned exception message' do
            expect(subject).to be_failure
            expect(subject.failure).to eq('Unable to enqueue email notification')
          end
        end
      end

      context 'when ProjectManagement::FetchTaskWithProjectService returns Failure' do
        before { allow(ProjectManagement::FetchTaskWithProjectService).to receive(:call).and_return(Failure('forwarded fetch service error'))}

        it 'returns Failure("forwarded fetch service error")' do
          expect(subject).to be_failure
          expect(subject.failure).to eq('forwarded fetch service error')
        end
      end
    end

    context 'when assigner not found' do
      let(:assignee) { FactoryBot.create(:user) }
      let(:assigner) { nil }
      before do
        allow(UserAccess::FetchByIdentifiersService).to receive(:call).and_return([assignee, assigner])
      end

      it 'returns Failure("User not found")' do
        expect(subject).to be_failure
        expect(subject.failure).to eq('User not found')
      end
    end

    context 'when assignee not found' do
      let(:assignee) { nil }
      let(:assigner) { FactoryBot.create(:user) }
      before do
        allow(UserAccess::FetchByIdentifiersService).to receive(:call).and_return([assignee, assigner])
      end

      it 'returns Failure("User not found")' do
        expect(subject).to be_failure
        expect(subject.failure).to eq('User not found')
      end
    end
  end

  context 'when payload doesnt contain all required fields' do
    let(:payload) { { assignee_identifier: nil, assigner_identifier: SecureRandom.uuid, task_identifier: SecureRandom.uuid }}

    it 'returns Failure("Payload is not valid")' do
      expect(subject).to be_failure
      expect(subject.failure).to eq('Payload is not valid')
    end
  end

  context 'when payload keys missing' do
    let(:payload) { { assigner_identifier: SecureRandom.uuid, task_identifier: SecureRandom.uuid }}

    it 'returns Failure("Payload is not valid")' do
      expect(subject).to be_failure
      expect(subject.failure).to eq('Payload is not valid')
    end
  end
end
