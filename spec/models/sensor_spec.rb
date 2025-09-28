require 'rails_helper'

RSpec.describe Sensor, type: :model do
  describe 'associations' do
    it { should belong_to(:company) }
    it { should have_many(:metrics).with_foreign_key('source').with_primary_key('code') }
  end

  describe 'validations' do
    subject { build(:sensor) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:code) }
    it { should validate_uniqueness_of(:code) }
  end

  describe 'metrics relationship' do
    let(:company) { create(:company) }
    let(:sensor) { create(:sensor, company: company, code: 'SENSOR001') }

    it 'associates metrics by code' do
      metric1 = create(:metric, source: sensor.code, name: 'pressure')
      metric2 = create(:metric, source: sensor.code, name: 'rpm')
      other_sensor = create(:sensor, code: 'OTHERSENSOR')
      metric3 = create(:metric, source: other_sensor.code, name: 'pressure')

      expect(sensor.metrics).to include(metric1, metric2)
      expect(sensor.metrics).not_to include(metric3)
    end

    it 'maintains metrics_count accurately' do
      expect(sensor.metrics_count).to eq(0)

      create(:metric, source: sensor.code)
      sensor.reload

      expect(sensor.metrics.count).to eq(1)
    end
  end

  describe 'company scoping' do
    let(:company1) { create(:company) }
    let(:company2) { create(:company) }
    let(:sensor1) { create(:sensor, company: company1) }
    let(:sensor2) { create(:sensor, company: company2) }

    it 'belongs to the correct company' do
      expect(sensor1.company).to eq(company1)
      expect(sensor2.company).to eq(company2)
    end

    it 'maintains company isolation' do
      expect(company1.sensors).to include(sensor1)
      expect(company1.sensors).not_to include(sensor2)
    end
  end

  describe 'code uniqueness' do
    it 'prevents duplicate codes globally' do
      sensor1 = create(:sensor, code: 'UNIQUE123')
      sensor2 = build(:sensor, code: 'UNIQUE123')

      expect(sensor2).not_to be_valid
      expect(sensor2.errors[:code]).to include('has already been taken')
    end

    it 'enforces global uniqueness across companies' do
      company1 = create(:company)
      company2 = create(:company)

      sensor1 = create(:sensor, company: company1, code: 'SHARED123')
      sensor2 = build(:sensor, company: company2, code: 'SHARED123')

      expect(sensor2).not_to be_valid
      expect(sensor2.errors[:code]).to include('has already been taken')
    end
  end

  describe 'factory' do
    it 'creates a valid sensor' do
      sensor = build(:sensor)
      expect(sensor).to be_valid
    end

    it 'generates unique codes' do
      sensor1 = create(:sensor)
      sensor2 = create(:sensor)
      expect(sensor1.code).not_to eq(sensor2.code)
    end
  end
end