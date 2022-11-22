module ProjectManagement
  class ProjectIndexQuery < ::DryService
    option :user_identifier, optional: true

    def call
      projects = Project.includes(:tasks)
      projects = projects.where(user_identifier: user_identifier) if user_identifier
      projects
    end
  end
end
