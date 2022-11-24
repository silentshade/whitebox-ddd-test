module ProjectManagement
  class TasksIndexQuery < ::DryService
    option :user_identifier, optional: true

    def call
      tasks = Task.joins(:assignees)
      tasks = tasks.where(assignees: { user_identifier: user_identifier }) if user_identifier
      tasks
    end
  end
end
