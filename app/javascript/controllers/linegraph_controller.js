// src/controllers/line_graph_controller.js
import { Controller } from "@hotwired/stimulus"

import "https://cdn.jsdelivr.net/npm/apexcharts"
export default class extends Controller {
  static targets = ["container"]
  static values = {
    data: Object
  }
  initialize() {
    this.datasets = {}
    this.chart = null
  }
  connect() {
    window.dataValue = this.dataValue
    this.datasets = Object.entries(this.dataValue).map(([sensor, points], idx) => ({
      name: sensor,
      data: points.map(([value, date]) => {

        return { x: Date.parse(date), y: value }
      }),

    }));
    window.datasets = this.datasets
    this.buildChart()
  }

  buildChart() {
    this.chart = new ApexCharts(this.containerTarget, this.defaultOptions())
    this.chart.render()
  }

  defaultOptions() {
    return {
      chart: {
        height: 380,
        width: "100%",
        type: "line",
        animations: {
          enabled: false,
          initialAnimation: {
            enabled: false
          }
        }
      },
      series: this.datasets,
      xaxis: {
        type: "datetime",
        labels: { datetimeUTC: false }
      },
      yaxis: {
        decimalsInFloat: 1
      },
      tooltip: {
        x: {
          show: true,
          format: 'dd-MM-yyyy H:mm',
        }
      }
    }
  }
}
