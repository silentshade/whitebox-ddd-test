module ProjectManagement
  class CreateAssigneeCommand < ::DryService
    option :user_identifier
    option :task_id
    option :email

    def call
      assignee = yield init_assignee(user_identifier, task_id, email)
      result = yield save_assignee(assignee)

      Success(result)
    end

    private

    def init_assignee(user_identifier, task_id, email)
      assignee = Assignee.new(user_identifier:, task_id:, email:)
      Success(assignee)
    end

    def save_assignee(assignee)
      return Success(assignee) if assignee.save

      Failure(assignee.errors.full_messages.join(', '))
    end
  end
end
