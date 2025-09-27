class MetricsChannel < ApplicationCable::Channel

  def subscribed
    stream_from "metrics_#{params[:code]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

end
