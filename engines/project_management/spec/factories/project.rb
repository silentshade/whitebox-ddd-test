FactoryBot.define do
  factory :project, class: 'ProjectManagement::Project' do
    title { 'Title' }
    description { 'Description' }
    identifier { "PR-#{sprintf("%04d", rand(1..9999))}"}
    user_identifier { SecureRandom.uuid }
  end
end
