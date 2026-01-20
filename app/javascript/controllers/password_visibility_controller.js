import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="password-visibility"
export default class extends Controller {
  static targets = ["input", "eye", "eyeOff"]

  connect() {
    this.visible = false
    this.syncIcons()
  }

  toggle() {
    this.visible = !this.visible
    this.inputTarget.type = this.visible ? "text" : "password"
    this.syncIcons()
  }

  syncIcons() {
    this.eyeTarget.classList.toggle("hidden", this.visible)
    this.eyeOffTarget.classList.toggle("hidden", !this.visible)
  }
}
