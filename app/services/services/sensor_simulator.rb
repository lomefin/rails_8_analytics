module Services
  class SensorSimulator

    attr_reader :mean, :stddev, :min, :max
    def initialize(mean:, stddev:, min: 0, max: 100)
      @mean = mean
      @stddev = stddev
      @min = min
      @max = max
    end

    def next_value
      rand_normal(mean:, stddev:, min:, max:)
    end

    private

      def rand_normal(mean: 10, stddev: 2.5, min: 5, max: 20)
        u1 = rand
        u2 = rand
        z0 = Math.sqrt(-2 * Math.log(u1)) * Math.cos(2 * Math::PI * u2)
        value = mean + z0 * stddev
        [ [ value, min ].max, max ].min
      end

  end
end
