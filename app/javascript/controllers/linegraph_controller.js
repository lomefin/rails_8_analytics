// src/controllers/line_graph_controller.js
import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"
import "https://cdn.jsdelivr.net/npm/apexcharts"
export default class extends Controller {
  static targets = ["container"]
  static values = {
    data: Object,
    topics: Array,
    dimension: String
  }
  initialize() {
    this.datasets = {}
    this.chart = null
    this.consumer = createConsumer()
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
    this.topicsValue.map((topic) => {
      this.subscribe(topic)
    })
  }

  addDataPoint(sensorName, timestamp, value) {
    const seriesIndex = this.datasets.findIndex(series => series.name === sensorName)
    if (seriesIndex === -1) { return }

    const newPoint = { x: Date.parse(timestamp), y: value }

    const newDataArray = this.datasets.map((series, index) => {
      if (index === seriesIndex) {
        return { data: [newPoint] }
      } else {
        return { data: [] }
      }
    })
    this.chart.appendData(newDataArray)

    if (this.datasets[seriesIndex].data.length > 1000) {
      this.removeExcessivePoints(seriesIndex)
    }
  }
  removeExcessivePoints(seriesIndex) {
    const pointsToRemove = this.datasets[seriesIndex].data.length - 1000
    this.datasets[seriesIndex].data.splice(0, pointsToRemove)

    this.chart.updateSeries(this.datasets)
  }
  subscribe(topic) {
    console.log("Subscribing to ", topic)
    this.consumer.subscriptions.create(
      { channel: 'MetricsChannel', code: topic },
      {
        connected: () => { console.log("Connected to", topic) },
        disconnected: () => { console.log("Disconnected from ", topic) },
        received: (data) => {
          if (data.name != this.dimensionValue) {
            return
          }
          this.addDataPoint(topic, data.ts, data.value)
        }
      }
    )
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
