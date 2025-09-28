require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:sessions).dependent(:destroy) }
    it { should belong_to(:company) }
  end

  describe 'validations' do
    subject { build(:user) }

    it { should validate_presence_of(:password) }
    it { should validate_uniqueness_of(:email_address).ignoring_case_sensitivity }
    it { should validate_uniqueness_of(:api_key) }
  end

  describe 'has_secure_password' do
    let(:user) { build(:user, password: 'password123') }

    it 'creates a password digest when password is set' do
      user.save!
      expect(user.password_digest).to be_present
    end

    it 'authenticates with correct password' do
      user.save!
      expect(user.authenticate('password123')).to eq(user)
    end

    it 'does not authenticate with incorrect password' do
      user.save!
      expect(user.authenticate('wrongpassword')).to be false
    end
  end

  describe 'email normalization' do
    it 'strips and downcases email addresses' do
      user = create(:user, email_address: '  JOHN@EXAMPLE.COM  ')
      expect(user.email_address).to eq('john@example.com')
    end
  end

  describe 'API key generation' do
    it 'generates an API key before creation' do
      user = build(:user)
      expect(user.api_key).to be_nil
      user.save!
      expect(user.api_key).to be_present
      expect(user.api_key).to match(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/)
    end

    it 'generates unique API keys for different users' do
      user1 = create(:user)
      user2 = create(:user)
      expect(user1.api_key).not_to eq(user2.api_key)
    end
  end

  describe 'company association' do
    it 'requires a company' do
      user = build(:user, company: nil)
      expect(user).not_to be_valid
      expect(user.errors[:company]).to include("must exist")
    end

    it 'belongs to a company' do
      company = create(:company)
      user = create(:user, company: company)
      expect(user.company).to eq(company)
    end
  end
end