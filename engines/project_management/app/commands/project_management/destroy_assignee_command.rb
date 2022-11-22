module ProjectManagement
  class DestroyAssigneeCommand < ::DryService
    option :assignee_id

    def call
      result = Assignee.destroy(assignee_id)

      Success(result)
    rescue StandardError => e
      Failure(e.message)
    end
  end
end
