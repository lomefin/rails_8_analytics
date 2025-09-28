require 'rails_helper'

RSpec.describe Services::SensorSimulator do
  describe 'initialization' do
    let(:simulator) { described_class.new(mean: 50, stddev: 10, min: 0, max: 100) }

    it 'sets mean correctly' do
      expect(simulator.mean).to eq(50)
    end

    it 'sets stddev correctly' do
      expect(simulator.stddev).to eq(10)
    end

    it 'sets min correctly' do
      expect(simulator.min).to eq(0)
    end

    it 'sets max correctly' do
      expect(simulator.max).to eq(100)
    end

    it 'uses default min and max when not provided' do
      default_simulator = described_class.new(mean: 25, stddev: 5)
      expect(default_simulator.min).to eq(0)
      expect(default_simulator.max).to eq(100)
    end
  end

  describe '#next_value' do
    let(:simulator) { described_class.new(mean: 50, stddev: 10, min: 10, max: 90) }

    it 'generates values within the specified range' do
      100.times do
        value = simulator.next_value
        expect(value).to be >= 10
        expect(value).to be <= 90
      end
    end

    it 'generates different values on consecutive calls' do
      values = 10.times.map { simulator.next_value }
      expect(values.uniq.length).to be > 1
    end

    it 'respects minimum bounds' do
      min_simulator = described_class.new(mean: 5, stddev: 20, min: 10, max: 100)
      100.times do
        value = min_simulator.next_value
        expect(value).to be >= 10
      end
    end

    it 'respects maximum bounds' do
      max_simulator = described_class.new(mean: 95, stddev: 20, min: 0, max: 90)
      100.times do
        value = max_simulator.next_value
        expect(value).to be <= 90
      end
    end
  end

  describe 'normal distribution behavior' do
    let(:simulator) { described_class.new(mean: 50, stddev: 10, min: 0, max: 100) }

    it 'generates values that tend toward the mean' do
      values = 1000.times.map { simulator.next_value }
      calculated_mean = values.sum / values.length

      # Allow for some variance but should be close to the specified mean
      expect(calculated_mean).to be_within(5).of(50)
    end

    it 'generates a reasonable distribution spread' do
      values = 1000.times.map { simulator.next_value }

      # Should have values in different ranges
      low_range = values.count { |v| v < 40 }
      mid_range = values.count { |v| v >= 40 && v <= 60 }
      high_range = values.count { |v| v > 60 }

      expect(low_range).to be > 50
      expect(mid_range).to be > 50
      expect(high_range).to be > 50
    end
  end

  describe 'edge cases' do
    it 'handles zero standard deviation' do
      zero_stddev_simulator = described_class.new(mean: 50, stddev: 0, min: 0, max: 100)
      values = 10.times.map { zero_stddev_simulator.next_value }

      # With zero stddev, all values should be at the mean (clamped by bounds)
      values.each do |value|
        expect(value).to be_within(1).of(50)
      end
    end

    it 'handles very narrow range' do
      narrow_simulator = described_class.new(mean: 50, stddev: 10, min: 49, max: 51)
      100.times do
        value = narrow_simulator.next_value
        expect(value).to be >= 49
        expect(value).to be <= 51
      end
    end

    it 'handles inverted mean outside bounds' do
      inverted_simulator = described_class.new(mean: 200, stddev: 10, min: 10, max: 50)
      100.times do
        value = inverted_simulator.next_value
        expect(value).to be >= 10
        expect(value).to be <= 50
      end
    end
  end

  describe 'private methods' do
    let(:simulator) { described_class.new(mean: 50, stddev: 10, min: 0, max: 100) }

    describe '#rand_normal' do
      it 'generates values following normal distribution pattern' do
        values = 1000.times.map { simulator.send(:rand_normal, mean: 50, stddev: 10, min: 0, max: 100) }

        # Basic sanity checks for normal distribution
        mean_value = values.sum / values.length
        expect(mean_value).to be_within(5).of(50)

        # Most values should be within 2 standard deviations
        within_2_sigma = values.count { |v| (v - 50).abs <= 20 }
        expect(within_2_sigma.to_f / values.length).to be > 0.8
      end
    end
  end
end