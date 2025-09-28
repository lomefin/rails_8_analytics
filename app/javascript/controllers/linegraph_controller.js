// src/controllers/line_graph_controller.js
import { Controller } from "@hotwired/stimulus"
import { Chart, LinearScale, PointElement, Tooltip, Legend, TimeScale } from "https://cdn.jsdelivr.net/npm/chart.js@4.5.0/+esm"
import "https://cdn.jsdelivr.net/npm/luxon@^2"
import "https://cdn.jsdelivr.net/npm/chartjs-adapter-luxon@^1"
export default class extends Controller {
  static targets = ["container"]
  static values = {
    data: Object
  }
  initialize() {
    console.log('Init')
    this.datasets = {}
    this.chart = null
  }
  connect() {
    // this.containerTarget.textContent = "Hello World!"
    console.log('Data', this.dataValue)
    window.dataValue = this.dataValue
    this.datasets = Object.entries(this.dataValue).map(([sensor, points], idx) => ({
      label: sensor,
      data: points.map(([date, value]) => ({ x: date, y: value })),
      borderColor: ["blue", "red", "green"][idx % 3],
      fill: false,
      tension: 0.1,
    }));
    window.datasets = this.datasets
    // this.containerTarget.textContent = "Preparing rendering"
    this.buildChart()
  }

  buildChart() {
    //const { Chart, TimeScale, LinearScale, PointElement, LineElement, Tooltip, Legend, Filler } = Chart;
    //Chart.register(Chart.adapters._date = Chart._adapters._date || {});
    //Chart.defaults.plugins.tooltip.mode = 'index';
    Chart.register(LinearScale, PointElement, Tooltip, Legend, TimeScale);
    window.chart = Chart
    const datasets = this.datasets
    this.chart = new Chart(this.containerTarget, {
      type: "line",
      data: { datasets },
      options: {
        responsive: true,
        parsing: false, // because we already supply {x,y}
        scales: {
          x: {
            type: "time"
            // , time: { unit: "day" } 
          },
          y: { beginAtZero: true },
          // xAxis: {
          //   type: 'time'
          // }
        },
      },
    });
  }
}
