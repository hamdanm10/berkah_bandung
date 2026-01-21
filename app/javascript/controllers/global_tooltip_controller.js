import { Controller } from "@hotwired/stimulus"

// data-controller="global-tooltip"
export default class extends Controller {
  static targets = ["tooltip", "content"]

  connect() {
    this.showTimeout = null
    this.currentTrigger = null
  }

  show(event) {
    const trigger = event.currentTarget
    const text = trigger.dataset.globalTooltip
    if (!text) return

    this.clearTimeout()
    this.currentTrigger = trigger

    this.tooltipTarget.classList.add("opacity-0")

    this.showTimeout = setTimeout(() => {
      if (this.currentTrigger !== trigger) return

      this.contentTarget.textContent = text

      const rect = trigger.getBoundingClientRect()
      const offset = 10

      this.tooltipTarget.style.top =
        `${rect.top - this.tooltipTarget.offsetHeight - offset}px`
      this.tooltipTarget.style.left =
        `${rect.left + rect.width / 2}px`
      this.tooltipTarget.style.transform = "translateX(-50%)"

      this.tooltipTarget.classList.remove("opacity-0")
    }, 300)
  }

  hide() {
    this.clearTimeout()
    this.tooltipTarget.classList.add("opacity-0")
  }

  clearTimeout() {
    if (this.showTimeout) {
      clearTimeout(this.showTimeout)
      this.showTimeout = null
    }
  }
}
