class GenerateRandomMetricsJob < ApplicationJob

  self.queue_adapter = :solid_queue
  queue_as :default

  def perform(every)
    @every = every
    Sensor.all.each do |sensor|
      build_metrics(sensor)
    end
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

  def rand_normal(mean: 10, stddev: 2.5, min: 5, max: 20)
    u1 = rand
    u2 = rand
    z0 = Math.sqrt(-2 * Math.log(u1)) * Math.cos(2 * Math::PI * u2)
    value = mean + z0 * stddev
    [ [ value, min ].max, max ].min
  end

  def rand_normal_05 = rand_normal(mean: 0.5, stddev: 0.25, min: 0, max: 1).round(4)

  def next_rate
    return rand_normal(mean: 3, stddev: 1, min: 1, max: 5) if fast?

    rand_normal
  end

  def next_event
    @rate_switch ||= 0.9
    @mode ||= :slow

    switch_mode! if rand > @rate_switch
    update_rate_switch

    next_rate
  end

  def build_metrics(sensor)
    time_limit = @every.minutes.from_now
    start = false
    threads = %i[pressure rpm].map do |name|
      Thread.new do
        simulator = Services::SensorSimulatorFactory.get(kind: name)
        loop do
          next unless start
          break if Time.current > time_limit

          Sensor.transaction { sensor.metrics.create(name:, value: simulator.next_value) }
          sleep next_event
        end
      end
    end
    start = true
    threads.join
  end

end
