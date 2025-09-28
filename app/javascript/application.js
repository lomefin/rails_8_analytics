// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

//import "./channels"

import LocalTime from "local-time"
console.log('application')
LocalTime.start()
document.addEventListener("turbo:morph", () => {
  LocalTime.run()
})

//import Chart from "chart.js/auto"
// import * as bootstrap from "bootstrap"
