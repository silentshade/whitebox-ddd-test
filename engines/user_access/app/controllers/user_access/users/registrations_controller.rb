# frozen_string_literal: true
module UserAccess
  class Users::RegistrationsController < Devise::RegistrationsController
    def create
      service = UserRegistrationService.new(user_params).call
      if service.success?
        redirect_to root_path
      else
        flash.now[:error] = service.error
        render :new, status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.require(:user).permit(
        :email, :password, :password_confirmation,
        :first_name, :last_name
      )
    end
  end
end
