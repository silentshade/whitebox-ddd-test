module ProjectManagement
  class UnassignedTasksPastDayQuery < ::DryService
    def call
      tasks = Task.left_joins(:assignees).where(project_management_assignees: { id: nil }).where('project_management_tasks.created_at < ?', Time.current - 24.hours)
      return Task.none unless tasks.any?

      tasks
    end
  end
end
