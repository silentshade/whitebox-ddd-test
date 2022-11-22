module ProjectManagement
  class Task < ApplicationRecord
    include ActiveModel::Validations
    validates_with IdentifierValidator

    validates :title, presence: true
  end
end
