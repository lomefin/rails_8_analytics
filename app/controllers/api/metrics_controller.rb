module API
  class MetricsController < BaseController

    def index
      @all_metrics = current_company.metrics.descending
      @all_metrics = @all_metrics.by_name(params[:name]) if params[:name].present?
      @all_metrics = @all_metrics.by_source(params[:source]) if params[:source].present?

      @all_metrics = @all_metrics.page params[:page]
      @sources = current_company.metrics.distinct(:source).pluck(:source)
      @dimensions = current_company.metrics.distinct(:name).pluck(:name)

      render :ok, json: index_result
    end

    def index_result
      next_page = (params[:page] || '1').to_i + 1
      prev_page = params[:page].to_i < 1 ? 0 : params[:page].to_i - 1
      {
        data: @all_metrics.map { |m| convert_metric(m)  },
        filter: {
          sources: @sources,
          names: @dimensions
        },
        links: {
          self: api_metrics_url(**params.to_unsafe_h.slice(:name, :source, :page)),
          next: api_metrics_url(page: next_page, source: params[:source], name: params[:name]),
          prev: api_metrics_url(page: prev_page, source: params[:source], name: params[:name])
        }
      }
    end

    def convert_metric(metric)
      {
        type: 'metric',
        id: metric.id,
        attributes: {
          source: metric.source,
          name: metric.name,
          value: metric.value,
          ts: metric.created_at.iso8601
        }
      }
    end

  end
end
