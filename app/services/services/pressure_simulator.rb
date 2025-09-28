module Services
  # Pressure sensor data simulator
  #
  # Generates realistic pressure readings for industrial sensor monitoring.
  # Configured with parameters appropriate for typical pressure sensors
  # that measure values in PSI or similar units.
  #
  # The simulator generates values centered around 40 units with moderate
  # variance, representing normal operating conditions in industrial equipment.
  #
  # @example Generating pressure readings
  #   simulator = PressureSimulator.new
  #   reading = simulator.next_value  # => 38.7 (PSI)
  #
  # @see SensorSimulator Base class for distribution mechanics
  # @version 1.0
  class PressureSimulator < SensorSimulator

    # Initializes a pressure simulator with industry-standard parameters
    #
    # Sets up the normal distribution with parameters suitable for
    # industrial pressure monitoring:
    # - Mean: 40 units (typical operating pressure)
    # - Standard deviation: 10 units (moderate variance)
    # - Range: 0-120 units (safe operating bounds)
    #
    # @example
    #   simulator = PressureSimulator.new
    #   # Ready to generate pressure readings between 0-120 units
    def initialize
      super(mean: 40, stddev: 10, min: 0, max: 120)
    end

  end
end
