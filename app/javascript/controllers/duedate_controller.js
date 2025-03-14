import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="duedate"
export default class extends Controller {
  static targets = ["container", "remainingDays"]
  static values = { startAt: String, endAt: String }

  connect() {
    const startDate = new Date(this.startAtValue);
    const endDate = new Date(this.endAtValue);
    const today = new Date();

    if (startDate > today) {
      this.remainingDaysTarget.innerText = "진행전";
      return
    }

    const remainingDays = Math.ceil((endDate - today) / (1000 * 60 * 60 * 24));

    if (remainingDays > 0) {
      this.containerTarget.classList.add("text-gray-500");
      this.remainingDaysTarget.innerText = `${remainingDays}일 남음`;
    } else {
      this.containerTarget.classList.add("text-red-500");
      this.remainingDaysTarget.innerText = `${Math.abs(remainingDays)}일 지남`;
    }
  }
}
