require 'rails_helper'

RSpec.describe Services::PressureSimulator do
  let(:simulator) { described_class.new }

  describe 'inheritance' do
    it 'inherits from SensorSimulator' do
      expect(simulator).to be_a(Services::SensorSimulator)
    end
  end

  describe 'initialization' do
    it 'sets pressure-specific parameters correctly' do
      expect(simulator.mean).to eq(40)
      expect(simulator.stddev).to eq(10)
      expect(simulator.min).to eq(0)
      expect(simulator.max).to eq(120)
    end
  end

  describe '#next_value' do
    it 'generates values within pressure range' do
      100.times do
        value = simulator.next_value
        expect(value).to be >= 0
        expect(value).to be <= 120
      end
    end

    it 'generates realistic pressure values' do
      values = 100.times.map { simulator.next_value }
      calculated_mean = values.sum / values.length

      # Should be around the specified mean for pressure
      expect(calculated_mean).to be_within(10).of(40)
    end

    it 'generates different values on consecutive calls' do
      values = 10.times.map { simulator.next_value }
      expect(values.uniq.length).to be > 1
    end
  end

  describe 'pressure-specific behavior' do
    it 'can generate low pressure values' do
      values = 1000.times.map { simulator.next_value }
      low_pressure_values = values.select { |v| v < 20 }
      expect(low_pressure_values).not_to be_empty
    end

    it 'can generate normal pressure values' do
      values = 1000.times.map { simulator.next_value }
      normal_pressure_values = values.select { |v| v >= 30 && v <= 50 }
      expect(normal_pressure_values).not_to be_empty
    end

    it 'can generate high pressure values' do
      values = 1000.times.map { simulator.next_value }
      high_pressure_values = values.select { |v| v > 60 }
      expect(high_pressure_values).not_to be_empty
    end

    it 'never generates negative pressure' do
      1000.times do
        value = simulator.next_value
        expect(value).to be >= 0
      end
    end

    it 'never exceeds maximum pressure threshold' do
      1000.times do
        value = simulator.next_value
        expect(value).to be <= 120
      end
    end
  end

  describe 'distribution characteristics' do
    let(:values) { 1000.times.map { simulator.next_value } }

    it 'generates a reasonable distribution around the mean' do
      mean_value = values.sum / values.length
      expect(mean_value).to be_within(5).of(40)
    end

    it 'has appropriate variance for pressure readings' do
      mean_value = values.sum / values.length
      variance = values.map { |v| (v - mean_value) ** 2 }.sum / values.length
      standard_deviation = Math.sqrt(variance)

      # Should have reasonable spread for pressure measurements
      expect(standard_deviation).to be > 5
      expect(standard_deviation).to be < 20
    end

    it 'covers the full operational range' do
      min_value = values.min
      max_value = values.max

      # Should generate values across a good portion of the range
      range_coverage = max_value - min_value
      expect(range_coverage).to be > 40  # Should cover at least 40 units of pressure
    end
  end

  describe 'realistic pressure simulation' do
    it 'simulates typical industrial pressure ranges' do
      values = 500.times.map { simulator.next_value }

      # Most values should be in typical operating ranges
      typical_range_values = values.select { |v| v >= 10 && v <= 80 }
      percentage_in_typical_range = typical_range_values.length.to_f / values.length

      expect(percentage_in_typical_range).to be > 0.7  # At least 70% in typical range
    end

    it 'occasionally generates extreme values' do
      values = 1000.times.map { simulator.next_value }

      # Should occasionally have very low or very high values
      extreme_low = values.select { |v| v < 15 }
      extreme_high = values.select { |v| v > 70 }

      # With normal distribution, should have some values in the tails
      expect(extreme_low.length + extreme_high.length).to be > 5
    end
  end
end