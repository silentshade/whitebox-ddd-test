devise_for :users, only: %i[sessions registrations confirmations], class_name: 'UserAccess::User', controllers: {
  sessions: 'user_access/users/sessions',
  registrations: 'user_access/users/registrations',
  confirmations: 'user_access/users/confirmations'
}
# devise_for :user_registrations, only: [:registrations, :confirmations], path: :users, class_name: 'UserAccess::UserRegistration', controllers: {
#   registrations: 'user_access/users/registrations',
#   confirmations: 'user_access/users/confirmations'
# }
