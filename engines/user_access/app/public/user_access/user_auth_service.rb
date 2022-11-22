# frozen_string_literal: true

module UserAccess
  class UserAuthService < ::DryService
    param :warden, required: true, reader: :private

    def call
      authenticate_user!

      self
    end

    def current_user_identifier
      @_current_user_identifier ||= warden.authenticate(scope: :user)&.identifier
    end

    private

    def authenticate_user!
      warden.authenticate!(scope: :user)
    end
  end
end
