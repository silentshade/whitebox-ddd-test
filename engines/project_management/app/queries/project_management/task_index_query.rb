module ProjectManagement
  class TaskIndexQuery < ::DryService
    option :project_id

    def call
      Task.where(project_id: project.id)
    end
  end
end
