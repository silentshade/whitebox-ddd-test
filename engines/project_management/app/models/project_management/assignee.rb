module ProjectManagement
  class Assignee < ApplicationRecord
    validates :user_identifier, :email, presence: true
    validates :email, format: Devise.email_regexp
  end
end
