# frozen_string_literal: true

class LineGraphComponent < ViewComponent::Base

  def initialize(title:, values:, topics:, sensor: nil)
    @title = title
    @values = values
    @topics = topics
    @sensor = sensor
  end


  def title = @title.titleize

  def values = @values.to_json

  def id = @sensor ? helpers.dom_id(sensor) : SecureRandom.uuid

end
