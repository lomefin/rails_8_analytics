require 'rails_helper'

RSpec.describe Services::RPMSimulator do
  let(:simulator) { described_class.new }

  describe 'inheritance' do
    it 'inherits from SensorSimulator' do
      expect(simulator).to be_a(Services::SensorSimulator)
    end
  end

  describe 'initialization' do
    it 'sets RPM-specific parameters correctly' do
      expect(simulator.mean).to eq(100)
      expect(simulator.stddev).to eq(33)
      expect(simulator.min).to eq(0)
      expect(simulator.max).to eq(1000)
    end
  end

  describe '#next_value' do
    it 'generates values within RPM range' do
      100.times do
        value = simulator.next_value
        expect(value).to be >= 0
        expect(value).to be <= 1000
      end
    end

    it 'generates realistic RPM values' do
      values = 100.times.map { simulator.next_value }
      calculated_mean = values.sum / values.length

      # Should be around the specified mean for RPM
      expect(calculated_mean).to be_within(20).of(100)
    end

    it 'generates different values on consecutive calls' do
      values = 10.times.map { simulator.next_value }
      expect(values.uniq.length).to be > 1
    end
  end

  describe 'RPM-specific behavior' do
    it 'can generate idle RPM values' do
      values = 1000.times.map { simulator.next_value }
      idle_rpm_values = values.select { |v| v < 50 }
      expect(idle_rpm_values).not_to be_empty
    end

    it 'can generate normal operating RPM values' do
      values = 1000.times.map { simulator.next_value }
      normal_rpm_values = values.select { |v| v >= 80 && v <= 150 }
      expect(normal_rpm_values).not_to be_empty
    end

    it 'can generate high RPM values' do
      values = 1000.times.map { simulator.next_value }
      high_rpm_values = values.select { |v| v > 150 }
      expect(high_rpm_values).not_to be_empty
    end

    it 'never generates negative RPM' do
      1000.times do
        value = simulator.next_value
        expect(value).to be >= 0
      end
    end

    it 'never exceeds maximum RPM threshold' do
      1000.times do
        value = simulator.next_value
        expect(value).to be <= 1000
      end
    end
  end

  describe 'distribution characteristics' do
    let(:values) { 1000.times.map { simulator.next_value } }

    it 'generates a reasonable distribution around the mean' do
      mean_value = values.sum / values.length
      expect(mean_value).to be_within(15).of(100)
    end

    it 'has appropriate variance for RPM readings' do
      mean_value = values.sum / values.length
      variance = values.map { |v| (v - mean_value) ** 2 }.sum / values.length
      standard_deviation = Math.sqrt(variance)

      # Should have reasonable spread for RPM measurements
      expect(standard_deviation).to be > 20
      expect(standard_deviation).to be < 50
    end

    it 'covers a wide operational range' do
      min_value = values.min
      max_value = values.max

      # Should generate values across a good portion of the range
      range_coverage = max_value - min_value
      expect(range_coverage).to be > 150  # Should cover at least 150 RPM units
    end
  end

  describe 'realistic RPM simulation' do
    it 'simulates typical engine RPM ranges' do
      values = 500.times.map { simulator.next_value }

      # Most values should be in typical operating ranges
      typical_range_values = values.select { |v| v >= 20 && v <= 300 }
      percentage_in_typical_range = typical_range_values.length.to_f / values.length

      expect(percentage_in_typical_range).to be > 0.6  # At least 60% in typical range
    end

    it 'occasionally generates extreme RPM values' do
      values = 1000.times.map { simulator.next_value }

      # Should occasionally have very low or very high values
      extreme_low = values.select { |v| v < 30 }
      extreme_high = values.select { |v| v > 200 }

      # With normal distribution, should have some values in the tails
      expect(extreme_low.length + extreme_high.length).to be > 5
    end

    it 'simulates engine behavior patterns' do
      values = 100.times.map { simulator.next_value }

      # Should have variety in RPM readings (not all the same)
      unique_values = values.uniq.length
      expect(unique_values).to be > 50  # Should have many different readings

      # Should occasionally hit very low values (engine off/idle)
      very_low_values = values.select { |v| v < 10 }
      expect(very_low_values.length).to be >= 0  # Can have zero RPM readings
    end
  end

  describe 'performance characteristics' do
    it 'generates values quickly' do
      start_time = Time.current
      1000.times { simulator.next_value }
      end_time = Time.current

      # Should be very fast for real-time simulation
      expect(end_time - start_time).to be < 0.1
    end

    it 'maintains consistency across multiple instances' do
      simulator1 = described_class.new
      simulator2 = described_class.new

      # Both should have same configuration
      expect(simulator1.mean).to eq(simulator2.mean)
      expect(simulator1.stddev).to eq(simulator2.stddev)
      expect(simulator1.min).to eq(simulator2.min)
      expect(simulator1.max).to eq(simulator2.max)
    end
  end
end