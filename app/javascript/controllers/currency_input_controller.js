import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="currency-input"
export default class extends Controller {
  static targets = ["raw"]

  connect() {
    this.initValue()
  }

  initValue() {
    const raw = this.rawTarget.value
    if (!raw) return

    const input = this.element.querySelector("input[type='text']")
    input.value = this.formatIDR(raw)
  }

  handleInput(event) {
    const raw = event.target.value.replace(/\D/g, "")
    this.rawTarget.value = raw
    event.target.value = this.formatIDR(raw)
  }

  handleBlur(event) {
    if (this.rawTarget.value) {
      event.target.value = this.formatIDR(this.rawTarget.value)
    }
  }

  formatIDR(value) {
    if (!value) return ""
    return "Rp. " + new Intl.NumberFormat("id-ID").format(value)
  }
}
