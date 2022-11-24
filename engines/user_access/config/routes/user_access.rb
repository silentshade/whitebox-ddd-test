devise_for :users, only: %i[sessions registrations confirmations], class_name: 'UserAccess::User', controllers: {
  sessions: 'user_access/users/sessions',
  registrations: 'user_access/users/registrations',
  confirmations: 'user_access/users/confirmations'
}
