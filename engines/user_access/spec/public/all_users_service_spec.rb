require 'rails_helper'

describe UserAccess::AllUsersService do
  let!(:users) { FactoryBot.create_list(:user, 10)}
  it 'returns all available users' do
    expect(described_class.new.call).to match_array(users)
  end
end
