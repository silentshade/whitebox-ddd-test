module ProjectManagement
  class DestroyTaskCommand < ::DryService
    option :task_id

    def call
      result = Task.destroy(task_id)

      Success(result)
    rescue StandardError => e
      Failure(e.message)
    end
  end
end
