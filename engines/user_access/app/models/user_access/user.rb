module UserAccess
  class User < ApplicationRecord
    devise :registerable, :database_authenticatable,
           :rememberable, :validatable

    attr_accessor :skip_password_validation
  end
end
