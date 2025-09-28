module Services
  # RPM (Revolutions Per Minute) sensor data simulator
  #
  # Generates realistic RPM readings for rotating machinery monitoring.
  # Configured with parameters appropriate for typical industrial equipment
  # such as motors, pumps, fans, and other rotating devices.
  #
  # The simulator generates values centered around 100 RPM with higher
  # variance to represent the dynamic nature of rotating equipment,
  # including idle states, normal operation, and high-speed conditions.
  #
  # @example Generating RPM readings
  #   simulator = RPMSimulator.new
  #   reading = simulator.next_value  # => 87.3 (RPM)
  #
  # @see SensorSimulator Base class for distribution mechanics
  # @version 1.0
  class RPMSimulator < SensorSimulator

    # Initializes an RPM simulator with machinery-appropriate parameters
    #
    # Sets up the normal distribution with parameters suitable for
    # rotating equipment monitoring:
    # - Mean: 100 RPM (typical operating speed)
    # - Standard deviation: 33 RPM (higher variance for dynamic behavior)
    # - Range: 0-1000 RPM (covers idle to high-speed operation)
    #
    # @example
    #   simulator = RPMSimulator.new
    #   # Ready to generate RPM readings between 0-1000 RPM
    def initialize
      super(mean: 100, stddev: 33, min: 0, max: 1000)
    end

  end
end
