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

    def available_users
      @_available_users ||= UserAccess::AllUsersService.new.call
    end

    def presenter_for(task)
      TaskRowPresenter.new(task: task, available_users: available_users)
    end
  end
end
