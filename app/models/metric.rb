class Metric < ApplicationRecord
  belongs_to :sensor, foreign_key: 'source', primary_key: 'code'

  after_create :broadcast_metric

  def broadcasteable_attributes
    { value:, name: }
  end

  def broadcast_metric
    ActionCable.server.broadcast("metrics_#{source}", broadcasteable_attributes)
  end
end
