// src/controllers/line_graph_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  initialize() {
    console.log('Init')
  }
  connect() {
    this.element.textContent = "Hello World!"
  }
}