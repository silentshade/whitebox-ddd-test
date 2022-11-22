module UserAccess
  class FetchByEmailService < ::DryService
    option :email, reader: :private

    def call
      User.find_by(email: email)
    end
  end
end
