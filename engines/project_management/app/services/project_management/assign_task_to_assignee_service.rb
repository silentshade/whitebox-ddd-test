module ProjectManagement
  class AssignTaskToAssigneeService < ::DryService
    option :task_id
    option :user_email

    def call
      user_identifier = yield fetch_user_identifier(user_email)
      yield find_task(task_id)
      yield user_may_be_assigned_check(user_identifier, task_id)
      result = yield create_assignee(user_identifier, task_id, user_email)

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
  end
end
