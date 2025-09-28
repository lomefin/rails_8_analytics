module Services
  # Factory class for creating sensor simulator instances
  #
  # Implements the Factory pattern to provide a centralized way of creating
  # appropriate simulator instances based on sensor type. This ensures
  # consistent simulator configuration and makes it easy to add new
  # sensor types in the future.
  #
  # @example Creating different simulators
  #   pressure_sim = SensorSimulatorFactory.get(kind: :pressure)
  #   rpm_sim = SensorSimulatorFactory.get(kind: :rpm)
  #
  # @version 1.0
  class SensorSimulatorFactory

    class << self

      # Creates a sensor simulator instance based on the specified type
      #
      # @param kind [Symbol] the type of simulator to create
      #   - :pressure - Returns a PressureSimulator for pressure readings
      #   - :rpm - Returns an RPMSimulator for rotation speed readings
      #
      # @return [SensorSimulator] a configured simulator instance
      #
      # @raise [NotImplementedError] if the requested simulator type is not supported
      #
      # @example Creating a pressure simulator
      #   simulator = SensorSimulatorFactory.get(kind: :pressure)
      #   reading = simulator.next_value
      #
      # @example Creating an RPM simulator
      #   simulator = SensorSimulatorFactory.get(kind: :rpm)
      #   speed = simulator.next_value
      def get(kind:)
        case kind
        when :pressure
          PressureSimulator.new
        when :rpm
          RPMSimulator.new
        else
          raise NotImplementedError.new(kind.to_s)
        end
      end

    end

  end
end
