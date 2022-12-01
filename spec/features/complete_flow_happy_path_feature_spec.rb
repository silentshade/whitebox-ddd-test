require 'rails_helper'

RSpec.feature 'complete flow', type: :feature, js: true do
  let!(:user) do
    UserAccess::User.create!(email: 'testuser@example.com', first_name: 'Test', last_name: 'User', password: '123456', identifier: SecureRandom.uuid)
  end
  let!(:assignee1) do
    FactoryBot.create(:user, first_name: 'John', last_name: 'Doe', email: 'assignee1@example.com', password: '123456')
  end
  let!(:assignee2) do
    FactoryBot.create(:user, first_name: 'John', last_name: 'Doe', email: 'assignee2@example.com')
  end

  after do
    Capybara.current_session.quit
  end

  scenario 'happy path' do
    login_user(user)
    create_project
    add_tasks
    add_assignees
    logout_user(user)
    login_user(assignee1)
    view_tasks
    logout_user(assignee1)
    login_user(user)
    delete_assignees
    delete_task
    delete_project
  end

  def login_user(user)
    visit '/'
    fill_in('Email', with: user.email)
    fill_in('Password', with: '123456')
    click_on('Log in')
    expect(page).to have_content('Projects')
  end

  def logout_user(user)
    within('nav') do
      click_on(user.email)
      click_on('Sign Out')
    end
    sleep 0.5
  end

  def view_tasks
    visit project_management_tasks_path
    expect(page).to have_content("[#{created_task.identifier}]#{created_task.title}")
  end

  def create_project
    click_on('Add New Project')
    expect(page).to have_content('New project')

    fill_in('Title', with: 'Test title')
    fill_in('Description', with: 'Test description')
    click_on('Submit')

    within('.card-header') do
      expect(page).to have_content('Test title')
    end
    within('.card-body') do
      expect(page).to have_content('Test description')
    end
  end

  def add_tasks
    within('.card-header') do
      click_on(created_project.identifier)
    end

    project_header = "[#{created_project.identifier}] #{created_project.title}"
    expect(page).to have_content(project_header)

    click_on('Add Task')
    expect(page).to have_content('New task')

    fill_in('Title', with: 'Test task')
    fill_in('Description', with: 'Test task description')
    click_on('Submit')

    expect(page).to have_content('Test task')
    expect(page).to have_content('Test task description')
  end

  def add_assignees
    [1,2].each do |n|
      within("#project_management_task_#{created_task.id} .dropdown") do
        find('button').click
        click_on("assignee#{n}@example.com")
      end
      user_el = page.find(".bi-person-bounding-box[title='assignee#{n}@example.com']")
      expect(user_el).to be_present
      expect(user_el).to have_sibling('a[data-turbo-method="delete"]')
    end
  end

  def delete_assignees
    visit project_management_project_path(created_project.id)

    [1,2].each do |n|
      user_el = page.find(".bi-person-bounding-box[title='assignee#{n}@example.com']")
      user_el.sibling('a[data-turbo-method="delete"]').click
      sleep 0.1 # Let alert open
      page.driver.browser.switch_to.alert.accept
      expect(page).not_to have_selector(".bi-person-bounding-box[title='assignee#{n}@example.com']")
    end
  end

  def delete_task
    within("#project_management_task_#{created_task.id}") do
      find('a[data-turbo-method="delete"]').click
      sleep 0.1 # Let alert open
    end
    page.driver.browser.switch_to.alert.accept
    expect(page).not_to have_content('Test task')
  end

  def delete_project
    click_on('Remove Project')
    sleep 0.1 # Let alert open
    page.driver.browser.switch_to.alert.accept
    expect(page).not_to have_content('Test title')
  end

  def created_project
    @_created_project ||= ProjectManagement::Project.take
  end

  def created_task
    @_created_task ||= ProjectManagement::Task.take
  end
end
