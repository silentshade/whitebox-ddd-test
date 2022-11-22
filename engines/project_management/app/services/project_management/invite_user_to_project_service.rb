module ProjectManagement
  class InviteUserToProjectService < ::DryService
    option :project_id
    option :user_email

    attr_reader :user_identifier

    def call
      return Failure("User not found for email #{user.email}") unless user_identifier_by_email

      add_user_to_project
      Success()
    end

    private

    def user_identifier_by_email
      user = UserAccess::FetchByEmailService.call(email: :user_email)
    end

    def add_user_to_project
      ProjectByIdQuery.call(project_id: project_id)
    end
  end
end
