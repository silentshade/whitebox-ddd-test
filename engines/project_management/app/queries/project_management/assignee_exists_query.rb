module ProjectManagement
  class AssigneeExistsQuery < ::DryService
    option :user_identifier
    option :task_id

    def call
      exists = Assignee.exists?(user_identifier: user_identifier, task_id: task_id)
      return Failure(:exists) if exists

      Success()
    end
  end
end
