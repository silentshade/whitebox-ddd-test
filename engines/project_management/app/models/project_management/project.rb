module ProjectManagement
  class Project < ApplicationRecord
    include ActiveModel::Validations
    validates_with IdentifierValidator

    validates :title, :user_identifier, presence: true

    has_many :tasks
  end
end
