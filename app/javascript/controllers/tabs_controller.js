import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tab"
export default class extends Controller {
  static targets = ["tab", "content"]

  connect() {
    if (this.tabTargets.length > 0) {
      this.activate(this.tabTargets[0])
    }
  }

  select(event) {
    event.preventDefault()
    this.activate(event.currentTarget)
  }

  activate(element) {
    this.tabTargets.forEach((tab, index) => {
      const panel = this.contentTargets[index]

      if (tab === element) {
        tab.classList.add("active", "text-indigo-600", "border-indigo-600")
        tab.classList.remove("text-gray-500", "border-transparent", "hover:border-gray-300")
        panel.classList.remove("hidden")
      } else {
        tab.classList.add("text-gray-500", "border-transparent", "hover:border-gray-300")
        tab.classList.remove("active", "text-indigo-600", "border-indigo-600")
        panel.classList.add("hidden")
      }
    })
  }
}
