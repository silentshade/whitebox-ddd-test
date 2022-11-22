module ProjectManagement
  class ProjectShowPresenter
    attr_reader :project
    delegate :id, :identifier, :title, :description, to: :project, allow_nil: true

    def initialize(project:)
      @project = project
    end

    def tasks
      ProjectTasksQuery.call(project_id: id)
    end

    def presenter_for(task)
      TaskRowPresenter.new(task: task)
    end
  end
end
