module ProjectManagement
  class UnassignedTasksPastDayQuery < ::DryService
    def call
      Task.left_joins(:assignees).where(project_management_assignees: { id: nil }).where('project_management_tasks.created_at < ?', Time.current - 24.hours)
    end
  end
end
