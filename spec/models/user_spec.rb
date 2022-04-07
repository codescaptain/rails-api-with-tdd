require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#validations' do
    it 'should have valid factory' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'should valid presence of attributes' do
      user = build(:user, login: nil, provider: nil)
      expect(user).to_not be_valid
      expect(user.errors.messages[:login]).to include('can\'t be blank')
      expect(user.errors.messages[:provider]).to include('can\'t be blank')
    end

    it 'should validate uniqueness of login' do
      user = create(:user)
      user_2 = build(:user, login: user.login)
      expect(user_2).to_not be_valid
      user_2.login = 'new_login'
      expect(user_2).to be_valid

    end
  end
end
