Rails.application.routes.draw do
  draw(:user_access)

  authenticated do
    root to: 'project_management/projects#index'
  end

  devise_scope :user do
    unauthenticated do
      root to: 'user_access/users/sessions#new', as: :unauthenticated_root
    end
  end

  namespace :project_management do
    resources :projects do
      resources :tasks, except: %i[index] do
        member do
          post :add_assignee
        end
      end
    end
    resources :assignees, only: %i[destroy]
    resources :tasks, only: %i[index]
  end
end
