module Services
  class SensorSimulatorFactory

    class << self

      def get(kind:)
        case kind
        when :pressure
          PressureSimulator.new
        when :rpm
          RPMSimulator.new
        else
          raise NotImplementedError(kind)
        end
      end

    end

  end
end
