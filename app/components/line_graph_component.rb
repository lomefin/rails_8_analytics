# frozen_string_literal: true

class LineGraphComponent < ViewComponent::Base

  def initialize(title:, values:, topics:)
    @title = title
    @values = values
    @topics = topics
  end


  def title = @title.titleize

  def values = @values.to_json

end
