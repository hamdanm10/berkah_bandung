import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="filter"
export default class extends Controller {
  static targets = ["panel"]

  connect() {
    this.isOpen = false
  }

  toggle() {
    this.isOpen ? this.close() : this.open()
  }

  open() {
    const panel = this.panelTarget

    panel.style.height = "0px"
    panel.classList.remove("opacity-0")
    panel.classList.add("opacity-100")

    panel.offsetHeight

    const height = panel.scrollHeight

    requestAnimationFrame(() => {
      panel.style.height = height + "px"
    })

    this.isOpen = true

    panel.addEventListener(
      "transitionend",
      () => {
        if (this.isOpen) panel.style.height = "auto"
      },
      { once: true }
    )
  }

  close() {
    const panel = this.panelTarget

    const height = panel.scrollHeight
    panel.style.height = height + "px"

    panel.offsetHeight

    requestAnimationFrame(() => {
      panel.style.height = "0px"
      panel.classList.remove("opacity-100")
      panel.classList.add("opacity-0")
    })

    this.isOpen = false
  }
}
