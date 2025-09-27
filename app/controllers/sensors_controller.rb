class SensorsController < ApplicationController

  def index
  end

  def show
  end

  def real_time
  end

  def overview
    @sensor_count = current_company.sensors.count
    @metrics_count = current_company.metrics.count
    @latest_metrics = current_company.metrics.maximum(:created_at)
    total_latencies = current_company.metrics.group(:source).maximum(:created_at)
    @latency = total_latencies.sum { |_, t| Time.current - t } / total_latencies.size
  end

end
