require 'rails_helper'

RSpec.feature 'create project', type: :feature do
  let!(:user) do
    UserAccess::User.create!(email: 'testuser@example.com', first_name: 'Test', last_name: 'User', password: '123456', identifier: SecureRandom.uuid)
  end

  context 'when user logged in' do
    before { sign_in user, scope: :user }

    scenario 'create project' do
      visit '/'

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

    scenario 'view existing project' do
      given_user_project_exists

      visit project_management_project_path(@project)
      project_header = "[#{@project.identifier}] #{@project.title}"
      expect(page).to have_content(project_header)
    end

    scenario 'destroy project' do
      given_user_project_exists

      visit project_management_project_path(@project)
      project_header = "[#{@project.identifier}] #{@project.title}"
      click_on('Remove Project')

      expect(page).not_to have_content(project_header)
    end
  end

  def given_user_project_exists
    @project = FactoryBot.create(:project, user_identifier: user.identifier)
  end
end
