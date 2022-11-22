FactoryBot.define do
  factory :task, class: 'ProjectManagement::Task' do
    project_id { FactoryBot.create(:project).id }
    title { 'Task' }
    description { 'Description' }
    identifier { "TA-#{sprintf("%04d", rand(1..9999))}"}
  end
end
