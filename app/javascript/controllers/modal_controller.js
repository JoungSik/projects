import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ["content"]

  connect() {
    document.body.classList.add('overflow-hidden');

    this.boundKeyHandler = this.handleKeyDown.bind(this);
    document.addEventListener('keydown', this.boundKeyHandler);
  }

  disconnect() {
    document.removeEventListener('keydown', this.boundKeyHandler);
    document.body.classList.remove('overflow-hidden');
  }

  handleKeyDown(event) {
    // ESC 키로 모달 닫기
    if (event.key === 'Escape') {
      this.close();
    }
  }

  close(event) {
    if (event && event.target === this.contentTarget) {
      event.stopPropagation();
      return;
    }

    document.body.classList.remove('overflow-hidden');

    this.element.remove();
  }
}