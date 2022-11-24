module ProjectManagement
  class TasksIndexPresenter
    attr_reader :current_user_identifier

    def initialize(current_user_identifier:)
      @current_user_identifier = current_user_identifier
    end

    def tasks
      @_tasks ||= TasksIndexQuery.call(user_identifier: current_user_identifier)
    end
  end
end
