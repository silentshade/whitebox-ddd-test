module ProjectManagement
  class TaskRowPresenter
    attr_reader :task
    delegate :id, :identifier, :title, :description, :project_id, :assignees, to: :task

    def initialize(task:)
      @task = task
    end

    def users
      @_users ||= UserAccess::AllUsersService.new.call
    end
  end
end
