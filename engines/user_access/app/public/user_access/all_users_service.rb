module UserAccess
  class AllUsersService

    def call
      User.all
    end
  end
end
