require 'rails_helper'

RSpec.describe Metric, type: :model do
  describe 'associations' do
    it { should belong_to(:sensor).with_foreign_key('source').with_primary_key('code') }
  end

  describe 'validations' do
    subject { build(:metric) }

    it { should validate_presence_of(:source) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:value) }
  end

  describe 'scopes' do
    let(:sensor) { create(:sensor, code: 'TEST001') }
    let!(:metric1) { create(:metric, source: sensor.code, name: 'pressure', value: 25.5, created_at: 1.hour.ago) }
    let!(:metric2) { create(:metric, source: sensor.code, name: 'rpm', value: 1500, created_at: 30.minutes.ago) }
    let!(:metric3) { create(:metric, source: sensor.code, name: 'pressure', value: 30.0, created_at: 10.minutes.ago) }

    describe '.descending' do
      it 'orders metrics by created_at in descending order' do
        metrics = Metric.descending
        expect(metrics).to eq([metric3, metric2, metric1])
      end
    end

    describe '.recently_created' do
      it 'returns metrics from the last hour by default' do
        metrics = Metric.recently_created
        expect(metrics).to include(metric2, metric3)
        expect(metrics).not_to include(metric1)
      end

      it 'accepts custom horizon parameter' do
        metrics = Metric.recently_created(horizon: 2)
        expect(metrics).to include(metric1, metric2, metric3)
      end

      it 'can order ascending' do
        metrics = Metric.recently_created(ordered: :asc)
        expect(metrics.first).to eq(metric2)
        expect(metrics.last).to eq(metric3)
      end
    end

    describe '.by_source' do
      let(:other_sensor) { create(:sensor, code: 'OTHER001') }
      let!(:other_metric) { create(:metric, source: other_sensor.code) }

      it 'filters by source' do
        metrics = Metric.by_source(sensor.code)
        expect(metrics).to include(metric1, metric2, metric3)
        expect(metrics).not_to include(other_metric)
      end
    end

    describe '.by_name' do
      it 'filters by metric name' do
        pressure_metrics = Metric.by_name('pressure')
        expect(pressure_metrics).to include(metric1, metric3)
        expect(pressure_metrics).not_to include(metric2)
      end
    end
  end

  describe 'ActionCable broadcasting' do
    let(:sensor) { create(:sensor, code: 'BROADCAST001') }

    it 'broadcasts after creation' do
      expect(ActionCable.server).to receive(:broadcast)
        .with("metrics_#{sensor.code}", { value: 42.5, name: 'pressure' })

      create(:metric, source: sensor.code, name: 'pressure', value: 42.5)
    end

    it 'includes correct broadcasteable attributes' do
      metric = build(:metric, source: sensor.code, name: 'rpm', value: 1200)
      expected_attributes = { value: 1200, name: 'rpm' }

      expect(metric.broadcasteable_attributes).to eq(expected_attributes)
    end
  end

  describe 'sensor relationship' do
    let(:company) { create(:company) }
    let(:sensor) { create(:sensor, company: company, code: 'REL001') }

    it 'belongs to the correct sensor by code' do
      metric = create(:metric, source: sensor.code, name: 'temperature', value: 23.5)
      expect(metric.sensor).to eq(sensor)
    end

    it 'raises error when sensor does not exist' do
      expect {
        create(:metric, source: 'NONEXISTENT', name: 'pressure', value: 10)
      }.to raise_error(ActiveRecord::RecordInvalid, /Sensor must exist/)
    end
  end

  describe 'value handling' do
    it 'stores decimal values correctly' do
      metric = create(:metric, value: 123.456789)
      expect(metric.value).to be_a(BigDecimal)
      expect(metric.value.to_f).to eq(123.456789)
    end

    it 'handles integer values' do
      metric = create(:metric, value: 100)
      expect(metric.value.to_f).to eq(100.0)
    end

    it 'handles zero values' do
      metric = create(:metric, value: 0)
      expect(metric.value.to_f).to eq(0.0)
    end
  end

  describe 'factory' do
    it 'creates a valid metric' do
      metric = build(:metric)
      expect(metric).to be_valid
    end

    it 'creates pressure trait correctly' do
      metric = build(:metric, :pressure)
      expect(metric.name).to eq('pressure')
      expect(metric.value).to be >= 0.0
      expect(metric.value).to be <= 120.0
    end

    it 'creates rpm trait correctly' do
      metric = build(:metric, :rpm)
      expect(metric.name).to eq('rpm')
      expect(metric.value).to be >= 0.0
      expect(metric.value).to be <= 1000.0
    end
  end
end