import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle-switch"
export default class extends Controller {
  static targets = ["checkbox", "background", "handle"]

  connect() {
    this.updateToggleState()
  }

  toggle() {
    this.updateToggleState()
  }

  updateToggleState() {
    if (this.checkboxTarget.checked) {
      this.backgroundTarget.classList.add('bg-indigo-600')
      this.backgroundTarget.classList.remove('bg-gray-200')
      this.handleTarget.classList.add('translate-x-5')
      this.handleTarget.classList.remove('translate-x-0')
    } else {
      this.backgroundTarget.classList.remove('bg-indigo-600')
      this.backgroundTarget.classList.add('bg-gray-200')
      this.handleTarget.classList.remove('translate-x-5')
      this.handleTarget.classList.add('translate-x-0')
    }
  }
}
