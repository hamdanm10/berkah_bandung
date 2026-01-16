import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="password-visibility"
export default class extends Controller {
  static targets = ["input", "eye", "eyeOff"]

  toggle() {
    const isPassword = this.inputTarget.type === "password"

    this.inputTarget.type = isPassword ? "text" : "password"

    this.eyeTarget.classList.toggle("hidden", !isPassword)
    this.eyeOffTarget.classList.toggle("hidden", isPassword)
  }
}
