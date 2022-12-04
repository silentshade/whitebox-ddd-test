# frozen_string_literal: true

module ProjectManagement
  class AssignTaskToAssigneeService < ::DryService
    EVENT_NAME = 'project_management_domain_event.task_assigned'
    option :task_id
    option :user_email
    option :current_user_identifier

    def call
      user_identifier = yield fetch_user_identifier(user_email)
      task = yield find_task(task_id)
      yield user_may_be_assigned_check(user_identifier, task_id)
      result = yield create_assignee(user_identifier, task_id, user_email)
      yield instrument_notification(user_identifier, current_user_identifier, task.identifier)

      Success(result)
    end
    
    private
    
    def fetch_user_identifier(user_email)
      user = UserAccess::FetchByEmailService.call(email: user_email)
      return Success(user.identifier) if user

      Failure('User not found')
    end

    def find_task(task_id)
      TaskByIdQuery.call(task_id: task_id)
    end

    def user_may_be_assigned_check(user_identifier, task_id)
      return Failure('Task is already assigned to this user') if AssigneeExistsQuery.call(user_identifier:, task_id:).failure?

      Success()
    end

    def create_assignee(user_identifier, task_id, email)
      CreateAssigneeCommand.call(user_identifier:, task_id:, email:)
    end

    def instrument_notification(assignee_identifier, assigner_identifier, task_identifier)
      result = ActiveSupport::Notifications.instrument(EVENT_NAME, {assignee_identifier:, assigner_identifier:, task_identifier:})
      Success(result)
    rescue StandardError => e
      Failure(e.message)
    end
  end
end
