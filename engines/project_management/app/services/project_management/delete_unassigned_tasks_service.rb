module ProjectManagement
  class DeleteUnassignedTasksService < ::DryService
    include BackgroundTaskExecutionReporter

    def call
      execute_and_log(self.class.name) do
        tasks = yield find_tasks
        result = yield delete_tasks(tasks)

        Success(result)
      end
    end

    private

    def find_tasks
      result = UnassignedTasksPastDayQuery.call
      Success(result)
    end

    def delete_tasks(tasks)
      DeleteTasksCommand.call(tasks: tasks)
    end
  end
end
