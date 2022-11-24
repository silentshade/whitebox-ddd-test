FactoryBot.define do
  factory :user, class: 'UserAccess::User' do
    sequence(:email) { |n| "example#{n}@example.com" }
    first_name { 'John' }
    last_name { 'Doe' }
    identifier { SecureRandom.uuid }
    password { '123456' }
  end
end
