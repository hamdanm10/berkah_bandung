import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="shortcut"
export default class extends Controller {
  static values = {
    key: String
  }

  connect() {
    this.handleKeydown = this.handleKeydown.bind(this)
    document.addEventListener("keydown", this.handleKeydown)
  }

  disconnect() {
    document.removeEventListener("keydown", this.handleKeydown)
  }

  handleKeydown(event) {
    if (!this.keyValue) return

    if (this.matchShortcut(event, this.keyValue)) {
      event.preventDefault()
      this.element.click()
      this.focusNext()
    }
  }

  focusNext() {
    const focusable = Array.from(
      document.querySelectorAll(
        `
      input:not([disabled]):not([tabindex="-1"]),
      select:not([disabled]):not([tabindex="-1"]),
      textarea:not([disabled]):not([tabindex="-1"]),
      button:not([disabled]):not([tabindex="-1"]),
      [tabindex]:not([tabindex="-1"])
      `
      )
    ).filter(el => el.offsetParent !== null)

    const index = focusable.indexOf(document.activeElement)

    if (index > -1 && focusable[index + 1]) {
      focusable[index + 1].focus()
    }
  }



  matchShortcut(event, shortcut) {
    const parts = shortcut.toLowerCase().split("+")
    const key = parts.pop()

    return (
      (!parts.includes("ctrl") || event.ctrlKey) &&
      (!parts.includes("alt") || event.altKey) &&
      (!parts.includes("shift") || event.shiftKey) &&
      (!parts.includes("meta") || event.metaKey) &&
      event.key.toLowerCase() === key
    )
  }
}
