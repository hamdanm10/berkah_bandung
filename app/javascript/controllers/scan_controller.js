import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="scan-controller.js"
export default class extends Controller {
  static targets = ["orderNumber", "trackingNumber"]

  connect() {
    [...this.orderNumberTargets, ...this.trackingNumberTargets].forEach((field) => {
      field.addEventListener("keydown", (e) => {
        if (e.key === "Enter") {
          e.preventDefault()
          this.focusNext(field)
        }
      })
    })
  }

  focusNext(current) {
    current.form?.elements[
      Array.from(current.form.elements).indexOf(current) + 1
    ]?.focus()
  }
}
