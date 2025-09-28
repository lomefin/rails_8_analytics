class MetricsController < ApplicationController

  before_action :load_previous_data, only: :real_time
  def real_time
  end

  def index
    @all_metrics = current_company.metrics.descending
    @all_metrics = @all_metrics.by_name(params[:name]) if params[:name].present?
    @all_metrics = @all_metrics.by_source(params[:source]) if params[:source].present?

    @all_metrics = @all_metrics.page params[:page]
    @sources = current_company.metrics.distinct(:source).pluck(:source)
    @dimensions = current_company.metrics.distinct(:name).pluck(:name)
  end


  def load_previous_data
    all_metrics = current_company.metrics.recently_created
    @dimensions = current_company.metrics.distinct(:name).pluck(:name)
    @data = @dimensions.to_h do |dim|
      metrics_of_dim = all_metrics.where(name: dim)
      sources = all_metrics.distinct(:source).pluck(:source)
      values_by_source = sources.to_h do |source|
        [source, metrics_of_dim.where(source:).pluck(:value, :created_at).map { |(v, date)| [v.to_d.round(4), date.iso8601] }]
      end
      [dim, values_by_source]
    end
  end

end
