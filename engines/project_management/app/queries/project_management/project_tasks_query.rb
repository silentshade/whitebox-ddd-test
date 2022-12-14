module ProjectManagement
  class ProjectTasksQuery < ::DryService
    option :project_id

    def call
      Task.where(project_id: project_id).includes(:assignees)
    end
  end
end
