module Services
  class PressureSimulator < SensorSimulator

    def initialize
      super(mean: 40, stddev: 10, min: 0, max: 120)
    end

  end
end
