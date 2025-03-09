import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sidebar"
export default class extends Controller {
  static targets = ["sidebar", "overlay"]
  static values = { showed: { type: Boolean, default: false } }

  toggle() {
    if (this.showedValue) {
      this.sidebarTarget.classList.remove("translate-x-0");
      this.sidebarTarget.classList.add("-translate-x-full");
      this.overlayTarget.classList.add("hidden");
    } else {
      this.sidebarTarget.classList.remove("-translate-x-full");
      this.sidebarTarget.classList.add("translate-x-0");
      this.overlayTarget.classList.remove("hidden");
    }

    this.showedValue = !this.showedValue;
  }
}