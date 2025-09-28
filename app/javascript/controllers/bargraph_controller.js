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
  roundToMinute(date) {
    const newDate = new Date(date)
    newDate.setSeconds(0, 0)
    return newDate
  }
  buildHistogram(points) {
    const mappedPoints = points.map(([value, date]) => {

      return { x: this.roundToMinute(Date.parse(date)), y: value }
    })
    const reducedPoints = mappedPoints.reduce((acc, value) => {
      console.log(value)
      const minute = value.x
      acc[minute] = (acc[minute] || 0) + 1
      return acc
    }, {})
    return Object.entries(reducedPoints).map(([key, val]) => {
      return { x: key, y: val }
    })
  }
  connect() {
    window.dataValue = this.dataValue
    this.datasets = Object.entries(this.dataValue).map(([sensor, points], idx) => ({
      name: sensor,
      data: this.buildHistogram(points)

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
    return
    this.consumer.subscriptions.create(
      { channel: 'MetricsChannel', code: topic },
      {
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
        type: "bar",
        stacked: true,
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
