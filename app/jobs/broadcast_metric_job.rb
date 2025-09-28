class BroadcastMetricJob < ApplicationJob

  queue_as :default

  def perform(metric_id:)
    metric = Metric.find(metric_id)
    metric.broadcast_metric!
  end

end
