module Services
  class MetricsSimulator

    attr_reader :sensor, :kind, :end_time, :current_time
    def initialize(sensor, kind, start_time: 1.hours.ago, end_time: Time.current)
      @sensor = sensor
      @kind = kind
      @simulator = Services::SensorSimulatorFactory.get(kind:)
      @current_time = start_time
      @end_time = end_time
    end

    def simulate!
      print "Sensor #{sensor.id} #{kind}: [#{' ' * 20}]"
      print "\e[21D"
      chars_written = 0
      loop do
        next_event!
        break if current_time > end_time

        print '.'
        chars_written += 1
        if chars_written > 20
          print "]\e[22D"
          chars_written = 0
        end
        sensor.metrics.create(name: kind, value: @simulator.next_value, created_at: current_time, updated_at: current_time)
      end
      puts
    end

    def switch_mode!
      @mode = fast? ? :slow : :fast

      @rate_switch = 0.75 if fast?
    end

    def fast? = @mode == :fast

    def slow? = !fast?

    def update_rate_switch
      new_rate_switch = @rate_switch + rand(-0.01..0.01)
      return @rate_switch if new_rate_switch > 0.99
      return @rate_switch if new_rate_switch < 0.75

      @rate_switch = new_rate_switch
    end

    def fast_rand_normal
      1.5 - [ rand, rand, rand ].sum * 1.88
    end

    def rand_normal(mean: 10, stddev: 1.6, min: 5, max: 20)
      u1 = rand
      u2 = rand
      z0 = Math.sqrt(-2 * Math.log(u1)) * Math.cos(2 * Math::PI * u2)
      value = mean + z0 * stddev
      [ [ value, min ].max, max ].min
    end

    def rand_normal_05 = rand_normal(mean: 2, stddev: 0.5, min: 0.5, max: 4).round(2)

    def next_rate
      return rand_normal(mean: 3, stddev: 1, min: 1, max: 5) if fast?

      rand_normal
    end

    def next_event!
      @rate_switch ||= 0.9
      @mode ||= :slow

      switch_mode! if rand > @rate_switch
      update_rate_switch

      @current_time = current_time + next_rate
    end

  end
end
