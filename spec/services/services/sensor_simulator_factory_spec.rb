require 'rails_helper'

RSpec.describe Services::SensorSimulatorFactory do
  describe '.get' do
    context 'with pressure kind' do
      let(:simulator) { described_class.get(kind: :pressure) }

      it 'returns a PressureSimulator instance' do
        expect(simulator).to be_a(Services::PressureSimulator)
      end

      it 'returns a simulator with pressure-specific parameters' do
        expect(simulator.mean).to eq(40)
        expect(simulator.stddev).to eq(10)
        expect(simulator.min).to eq(0)
        expect(simulator.max).to eq(120)
      end

      it 'returns a working simulator' do
        value = simulator.next_value
        expect(value).to be >= 0
        expect(value).to be <= 120
      end
    end

    context 'with rpm kind' do
      let(:simulator) { described_class.get(kind: :rpm) }

      it 'returns an RPMSimulator instance' do
        expect(simulator).to be_a(Services::RPMSimulator)
      end

      it 'returns a simulator with RPM-specific parameters' do
        expect(simulator.mean).to eq(100)
        expect(simulator.stddev).to eq(33)
        expect(simulator.min).to eq(0)
        expect(simulator.max).to eq(1000)
      end

      it 'returns a working simulator' do
        value = simulator.next_value
        expect(value).to be >= 0
        expect(value).to be <= 1000
      end
    end

    context 'with unsupported kind' do
      it 'raises NotImplementedError for unknown simulator type' do
        expect {
          described_class.get(kind: :temperature)
        }.to raise_error(NotImplementedError, 'temperature')
      end

      it 'raises NotImplementedError for nil kind' do
        expect {
          described_class.get(kind: nil)
        }.to raise_error(NotImplementedError, '')
      end

      it 'raises NotImplementedError for string kind' do
        expect {
          described_class.get(kind: 'unknown')
        }.to raise_error(NotImplementedError, 'unknown')
      end
    end

    context 'factory pattern behavior' do
      it 'returns different instances on multiple calls' do
        simulator1 = described_class.get(kind: :pressure)
        simulator2 = described_class.get(kind: :pressure)

        expect(simulator1).not_to be(simulator2)
        expect(simulator1.object_id).not_to eq(simulator2.object_id)
      end

      it 'returns instances of the same class for same kind' do
        simulator1 = described_class.get(kind: :rpm)
        simulator2 = described_class.get(kind: :rpm)

        expect(simulator1.class).to eq(simulator2.class)
        expect(simulator1).to be_a(Services::RPMSimulator)
        expect(simulator2).to be_a(Services::RPMSimulator)
      end

      it 'returns different classes for different kinds' do
        pressure_simulator = described_class.get(kind: :pressure)
        rpm_simulator = described_class.get(kind: :rpm)

        expect(pressure_simulator.class).not_to eq(rpm_simulator.class)
        expect(pressure_simulator).to be_a(Services::PressureSimulator)
        expect(rpm_simulator).to be_a(Services::RPMSimulator)
      end
    end

    context 'parameter consistency' do
      it 'returns simulators with consistent parameters for pressure' do
        simulator1 = described_class.get(kind: :pressure)
        simulator2 = described_class.get(kind: :pressure)

        expect(simulator1.mean).to eq(simulator2.mean)
        expect(simulator1.stddev).to eq(simulator2.stddev)
        expect(simulator1.min).to eq(simulator2.min)
        expect(simulator1.max).to eq(simulator2.max)
      end

      it 'returns simulators with consistent parameters for rpm' do
        simulator1 = described_class.get(kind: :rpm)
        simulator2 = described_class.get(kind: :rpm)

        expect(simulator1.mean).to eq(simulator2.mean)
        expect(simulator1.stddev).to eq(simulator2.stddev)
        expect(simulator1.min).to eq(simulator2.min)
        expect(simulator1.max).to eq(simulator2.max)
      end
    end

    context 'performance' do
      it 'creates simulators quickly' do
        start_time = Time.current
        100.times { described_class.get(kind: :pressure) }
        end_time = Time.current

        expect(end_time - start_time).to be < 0.1
      end
    end

    context 'supported simulator types' do
      it 'supports all expected simulator types' do
        expect { described_class.get(kind: :pressure) }.not_to raise_error
        expect { described_class.get(kind: :rpm) }.not_to raise_error
      end

      it 'provides documentation through error messages' do
        error_message = nil
        begin
          described_class.get(kind: :invalid)
        rescue NotImplementedError => e
          error_message = e.message
        end

        expect(error_message).to eq('invalid')
      end
    end
  end

  describe 'class structure' do
    it 'is a class with class methods' do
      expect(described_class).to be_a(Class)
      expect(described_class).to respond_to(:get)
    end

    it 'does not require instantiation' do
      # Should work without calling .new
      expect { described_class.get(kind: :pressure) }.not_to raise_error
    end
  end
end