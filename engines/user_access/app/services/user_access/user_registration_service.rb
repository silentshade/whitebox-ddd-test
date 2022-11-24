# frozen_string_literal: true

module UserAccess
  class UserRegistrationService
    ALLOWED_ATTRS = %i[email first_name last_name password password_confirmation].freeze

    attr_reader *ALLOWED_ATTRS
    attr_reader :error
    attr_reader :user

    def initialize(user_params = {})
      ALLOWED_ATTRS.each do |attr|
        instance_variable_set("@#{attr}", user_params[attr])
      end
    end

    def call
      new_user.save!

      self
    rescue StandardError => e
      @error = e
      self
    end

    def success?
      !@error
    end

    private

    def new_user
      @user = User.new(
        identifier: SecureRandom.uuid,
        email: email,
        first_name: first_name,
        last_name: last_name,
        password: password,
        password_confirmation: password_confirmation
      )
    end
  end
end
