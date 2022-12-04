module UserAccess
  class FetchByIdentifiersService < ::DryService
    option :identifiers, reader: :private

    def call
      User.where(identifier: identifiers)
    end
  end
end
