# frozen_string_literal: true

class BarGraphComponent < ViewComponent::Base

  def initialize(title:, values:, topics:, sensor: nil, dimension:)
    @title = title
    @values = values
    @topics = topics
    @sensor = sensor
    @dimension = dimension
  end


  def title = @title.titleize

  def values = @values.to_json

  def dimension = @dimension

  def id = @sensor ? helpers.dom_id(sensor) : SecureRandom.uuid

  def topics
    @topics.to_json
  end

end
