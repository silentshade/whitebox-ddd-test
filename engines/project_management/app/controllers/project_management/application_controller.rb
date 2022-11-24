module ProjectManagement
  class ApplicationController < ::ApplicationController
    before_action :authenticate_user!
    attr_reader :auth_service

    def current_user_identifier
      auth_service.current_user_identifier
    end

    private

    def authenticate_user!
      auth_service.call
    end

    def auth_service
      @_auth_service ||= UserAccess::UserAuthService.new(request.env['warden'])
    end
  end
end
