import { Controller } from "@hotwired/stimulus"

// data-controller="global-hint"
export default class extends Controller {
  static targets = ["hint", "content"]

  connect() {
    this.showTimeout = null
    this.currentTrigger = null
  }

  show(event) {
    const trigger = event.currentTarget
    const text = trigger.dataset.hint
    if (!text) return

    this.clearTimeout()
    this.currentTrigger = trigger

    this.hintTarget.classList.add("opacity-0")

    this.showTimeout = setTimeout(() => {
      if (this.currentTrigger !== trigger) return

      this.contentTarget.textContent = text

      const rect = trigger.getBoundingClientRect()
      const offset = 4

      this.hintTarget.style.top =
        `${rect.top - this.hintTarget.offsetHeight - offset}px`
      this.hintTarget.style.left =
        `${rect.left + rect.width / 2}px`
      this.hintTarget.style.transform = "translateX(-50%)"

      this.hintTarget.classList.remove("opacity-0")
    }, 300)
  }

  hide() {
    this.clearTimeout()
    this.hintTarget.classList.add("opacity-0")
  }

  clearTimeout() {
    if (this.showTimeout) {
      clearTimeout(this.showTimeout)
      this.showTimeout = null
    }
  }
}
