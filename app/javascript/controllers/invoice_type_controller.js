import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="invoice-type"
export default class extends Controller {
  static targets = [
    "type",
    "reference",
    "copy",
    "details",
    "adjustmentItem"
  ]

  connect() {
    this.toggle()
    this.toggleCopy()
    this.toggleAdjustmentItems()

    this.observeNestedItems()
  }

  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
  }

  toggle() {
    const value = this.typeTarget.value
    const showReference = value === "adjustment" || value === "return"

    this.toggleTarget(this.referenceTarget, showReference)
    this.toggleTarget(this.copyTarget, showReference)

    if (!showReference) {
      this.resetInputs(this.referenceTarget)
      this.resetInputs(this.copyTarget)
      this.detailsTarget.classList.remove("hidden")
    }

    this.toggleAdjustmentItems()
  }

  toggleCopy() {
    if (!this.hasCopyTarget) return

    const checkbox = this.copyTarget.querySelector('input[type="checkbox"]')
    if (!checkbox) return

    this.detailsTarget.classList.toggle("hidden", checkbox.checked)
  }

  toggleAdjustmentItems() {
    const isAdjustment = this.typeTarget.value === "adjustment"

    this.adjustmentItemTargets.forEach((el) => {
      el.classList.toggle("hidden", !isAdjustment)

      if (!isAdjustment) {
        this.resetInputs(el)
      }
    })
  }

  observeNestedItems() {
    this.observer = new MutationObserver(() => {
      this.toggleAdjustmentItems()
    })

    this.observer.observe(this.element, {
      childList: true,
      subtree: true
    })
  }

  toggleTarget(target, show) {
    if (!target) return
    target.classList.toggle("hidden", !show)
  }

  resetInputs(container) {
    if (!container) return

    container.querySelectorAll("input, select").forEach((el) => {
      if (el.type === "radio" || el.type === "checkbox") {
        el.checked = false
      } else {
        el.value = ""
      }
    })
  }
}
