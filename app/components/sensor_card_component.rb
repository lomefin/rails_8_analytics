# frozen_string_literal: true

class SensorCardComponent < ViewComponent::Base

  def initialize(name:, kind:, code:, icon:)
    @name = name
    @kind = kind
    @code = code
    @icon = icon
  end

end
