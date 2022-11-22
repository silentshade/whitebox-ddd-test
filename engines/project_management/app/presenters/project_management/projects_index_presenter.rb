module ProjectManagement
  class ProjectsIndexPresenter
    attr_reader :current_user_identifier

    def initialize(current_user_identifier:)
      @current_user_identifier = current_user_identifier
    end

    def projects
      @_projects ||= ProjectIndexQuery.call(current_user_identifier:)
    end
  end
end
