require 'rails_helper'

RSpec.describe Company, type: :model do
  describe 'associations' do
    it { should have_many(:users) }
    it { should have_many(:sensors) }
    it { should have_many(:metrics).through(:sensors) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'multi-tenancy' do
    let!(:company1) { create(:company, name: 'Company 1') }
    let!(:company2) { create(:company, name: 'Company 2') }
    let!(:sensor1) { create(:sensor, company: company1) }
    let!(:sensor2) { create(:sensor, company: company2) }
    let!(:user1) { create(:user, company: company1) }
    let!(:user2) { create(:user, company: company2) }

    it 'has isolated users between companies' do
      expect(company1.users).to include(user1)
      expect(company1.users).not_to include(user2)
      expect(company2.users).to include(user2)
      expect(company2.users).not_to include(user1)
    end

    it 'has isolated sensors between companies' do
      expect(company1.sensors).to include(sensor1)
      expect(company1.sensors).not_to include(sensor2)
      expect(company2.sensors).to include(sensor2)
      expect(company2.sensors).not_to include(sensor1)
    end

    it 'accesses metrics through sensors correctly' do
      metric1 = create(:metric, source: sensor1.code)
      metric2 = create(:metric, source: sensor2.code)

      expect(company1.metrics).to include(metric1)
      expect(company1.metrics).not_to include(metric2)
      expect(company2.metrics).to include(metric2)
      expect(company2.metrics).not_to include(metric1)
    end
  end

  describe 'factory' do
    it 'creates a valid company' do
      company = build(:company)
      expect(company).to be_valid
    end

    it 'generates a unique name' do
      company1 = create(:company)
      company2 = create(:company)
      expect(company1.name).not_to eq(company2.name)
    end
  end
end