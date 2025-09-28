# Metric model representing sensor data readings
#
# Metrics are time-series data points collected from sensors. Each metric
# belongs to a sensor (via the source/code relationship) and contains a
# measurement value with a name describing what was measured.
#
# Metrics are automatically broadcast via ActionCable when created to enable
# real-time dashboard updates.
#
# @example Creating and querying metrics
#   sensor = Sensor.find_by(code: 'PS001')
#   metric = Metric.create!(
#     source: sensor.code,
#     name: 'pressure',
#     value: 42.5
#   )
#   recent = Metric.recently_created.by_name('pressure')
#
# @version 1.0
class Metric < ApplicationRecord

  belongs_to :sensor, foreign_key: 'source', primary_key: 'code', counter_cache: :metrics_count

  after_create :schedule_broadcast_metric

  validates :source, presence: true
  validates :name, presence: true
  validates :value, presence: true


  scope :descending, -> { order(created_at: :desc) }
  scope :recently_created, ->(horizon: 1, ordered: :asc) { where(created_at: horizon.hours.ago..).order(created_at: ordered) }
  scope :by_source, ->(source) { where(source:) }
  scope :by_name, ->(name) { where(name:) }

  # Returns attributes suitable for ActionCable broadcasting
  #
  # Provides a filtered set of attributes for real-time updates,
  # excluding internal IDs and timestamps that aren't needed
  # for dashboard display.
  #
  # @return [Hash] hash containing value and name for broadcasting
  def broadcasteable_attributes
    { value:, name:, ts: created_at.iso8601 }
  end

  # Broadcasts the metric data via ActionCable
  #
  # Sends the metric data to all subscribers of the sensor's channel
  # to enable real-time dashboard updates. Called automatically
  # after metric creation.
  def broadcast_metric!
    ActionCable.server.broadcast("metrics_#{source}", broadcasteable_attributes)
  end

  def schedule_broadcast_metric
    BroadcastMetricJob.perform_later(metric_id: id)
  end

end
