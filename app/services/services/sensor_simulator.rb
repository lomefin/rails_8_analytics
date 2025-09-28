module Services
  # Base class for sensor data simulation using normal distribution
  #
  # This class provides a foundation for simulating realistic sensor readings
  # by generating values that follow a normal (Gaussian) distribution pattern,
  # constrained within specified minimum and maximum bounds.
  #
  # The simulator uses the Box-Muller transformation to generate normally
  # distributed values from uniformly distributed random numbers.
  #
  # @example Basic usage
  #   simulator = SensorSimulator.new(mean: 50, stddev: 10, min: 0, max: 100)
  #   value = simulator.next_value  # => 47.3
  #
  # @version 1.0
  class SensorSimulator

    # @return [Numeric] the mean value around which readings are centered
    # @return [Numeric] the standard deviation controlling spread of values
    # @return [Numeric] the minimum allowable value
    # @return [Numeric] the maximum allowable value
    attr_reader :mean, :stddev, :min, :max

    # Initializes a new sensor simulator with distribution parameters
    #
    # @param mean [Numeric] the center point of the normal distribution
    # @param stddev [Numeric] the standard deviation (spread) of the distribution
    # @param min [Numeric] the minimum value that can be generated (default: 0)
    # @param max [Numeric] the maximum value that can be generated (default: 100)
    #
    # @example Creating a temperature simulator
    #   simulator = SensorSimulator.new(mean: 23.5, stddev: 2.0, min: -10, max: 50)
    def initialize(mean:, stddev:, min: 0, max: 100)
      @mean = mean
      @stddev = stddev
      @min = min
      @max = max
    end

    # Generates the next sensor reading value
    #
    # Uses the configured normal distribution parameters to generate a realistic
    # sensor reading. Values are automatically clamped to the specified min/max bounds.
    #
    # @return [Numeric] a sensor reading value within the configured range
    #
    # @example
    #   value = simulator.next_value  # => 42.7
    def next_value
      rand_normal(mean:, stddev:, min:, max:)
    end

    private

      # Generates a normally distributed random value using Box-Muller transformation
      #
      # This method implements the Box-Muller algorithm to transform uniformly
      # distributed random values into normally distributed ones. The result
      # is then clamped to the specified bounds.
      #
      # @param mean [Numeric] center of the distribution
      # @param stddev [Numeric] standard deviation of the distribution
      # @param min [Numeric] minimum allowable value
      # @param max [Numeric] maximum allowable value
      # @return [Numeric] a normally distributed value within bounds
      #
      # @note This is a private method used internally by next_value
      def rand_normal(mean: 10, stddev: 2.5, min: 5, max: 20)
        u1 = rand
        u2 = rand
        z0 = Math.sqrt(-2 * Math.log(u1)) * Math.cos(2 * Math::PI * u2)
        value = mean + z0 * stddev
        [ [ value, min ].max, max ].min
      end

  end
end
