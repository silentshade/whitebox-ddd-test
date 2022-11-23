FactoryBot.define do
  factory :assignee, class: 'ProjectManagement::Assignee' do
    association(:task)
    email { 'example@example.com' }
    user_identifier { SecureRandom.uuid }
  end
end
