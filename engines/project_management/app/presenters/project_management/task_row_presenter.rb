module ProjectManagement
  class TaskRowPresenter
    attr_reader :task
    delegate :id, :identifier, :title, :description, :project_id, to: :task

    def initialize(task:)
      @task = task
    end

    def users
      @_users ||= UserAccess::AllUsersService.new.call
    end

    def assignees
      @_assignees ||= AssigneesForTaskQuery.call(task_id: task.id)
    end
  end
end
