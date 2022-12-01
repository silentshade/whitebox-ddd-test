module ProjectManagement
  class DeleteTasksCommand < ::DryService
    option :tasks

    def call
      result = tasks.delete_all
      Success(result)
    rescue StandardError => e
      Failure(e.message)
    end
  end
end
