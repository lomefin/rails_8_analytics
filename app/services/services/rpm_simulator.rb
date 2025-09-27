module Services
  class RPMSimulator < SensorSimulator

    def initialize
      super(mean: 100, stddev: 33, min: 0, max: 1000)
    end

  end
end
