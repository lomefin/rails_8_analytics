class Metric < ApplicationRecord

  belongs_to :sensor, foreign_key: 'source', primary_key: 'code'

  after_create :broadcast_metric

  scope :descending, -> { order(created_at: :desc) }
  scope :recently_created, ->(horizon: 1, ordered: :asc) { where(created_at: horizon.hours.ago..).order(created_at: ordered) }
  scope :by_source, ->(source) { where(source:) }
  scope :by_name, ->(name) { where(name:) }

  def broadcasteable_attributes
    { value:, name: }
  end

  def broadcast_metric
    ActionCable.server.broadcast("metrics_#{source}", broadcasteable_attributes)
  end

end
