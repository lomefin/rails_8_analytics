# frozen_string_literal: true

class KPIComponent < ViewComponent::Base

  def initialize(title:, value:, unit: nil)
    @title = title
    @value = value
    @unit = unit
  end

  def title = @title.titleize

  def unit = @unit&.titleize || '&nbsp'.html_safe

  def value_is_date?
    return true if @value.is_a? ActiveSupport::TimeWithZone
    return true if @value.is_a? Date

    false
  end

  def value
    case @value
    when Integer
      @value
    when Numeric
      @value.to_d.round(2)
    else
      @value
    end
  end

end
