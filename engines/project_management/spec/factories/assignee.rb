FactoryBot.define do
  factory :assignee, class: 'ProjectManagement::Assignee' do
    task_id { 100 }
    email { 'example@example.com' }
    user_identifier { SecureRandom.uuid }
  end
end
