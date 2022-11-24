# frozen_string_literal: true

module UserAccess
  class UserAuthService
    attr_reader :warden, :error

    def initialize(warden)
      @warden = warden
    end

    def call
      authenticate_user!
      self
    rescue StandardError => e
      @error = e
      self
    end

    def success?
      !@error
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
