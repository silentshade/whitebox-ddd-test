module ProjectManagement
  class TaskRowPresenter
    attr_reader :task, :available_users
    delegate :id, :identifier, :title, :description, :project_id, :assignees, to: :task

    def initialize(task:, available_users:)
      @task = task
      @available_users = available_users
    end

    def assignee_identifiers
      @_assignee_identifiers ||= assignees.map(&:user_identifier)
    end

    def users
      @_users ||= @available_users.select {|u| !assignee_identifiers.include?(u.identifier) }
    end
  end
end
