import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ["modal"];

  connect() {
    document.addEventListener("keydown", this.keydownHandler.bind(this));
  }

  disconnect() {
    document.removeEventListener("keydown", this.keydownHandler.bind(this));
  }

  keydownHandler(event) {
    if (event.key === "Escape") {
      this.close(event);
    }
  }

  open(event) {
    event.preventDefault();
    const modalId = event.currentTarget.dataset.modalId;
    const modal = document.getElementById(modalId);
    if (modal) {
      modal.classList.remove("hidden");
    }
  }

  close(event) {
    if (event.target === event.currentTarget) {
      this.modalTargets.forEach((modal) => modal.classList.add("hidden"));
    }
  }
}
