import { Controller } from "@hotwired/stimulus"

// data-controller="filter"
export default class extends Controller {
  static targets = ["panel"]
  static values = {
    initialOpen: Boolean
  }

  connect() {
    this.isOpen = this.initialOpenValue

    const panel = this.panelTarget
    if (this.isOpen) {
      panel.classList.add("opacity-100")
      panel.style.height = "auto"
    } else {
      panel.classList.add("opacity-0")
      panel.style.height = "0px"
    }
  }

  toggle() {
    this.isOpen ? this.hide() : this.show()
  }

  show() {
    const panel = this.panelTarget
    this.isOpen = true

    panel.classList.remove("opacity-0")
    panel.classList.add("opacity-100")

    panel.style.height = "0px"
    panel.offsetHeight

    const height = panel.scrollHeight

    requestAnimationFrame(() => {
      panel.style.height = `${height}px`
    })

    panel.addEventListener(
      "transitionend",
      () => {
        if (this.isOpen) panel.style.height = "auto"
      },
      { once: true }
    )
  }

  hide() {
    const panel = this.panelTarget
    this.isOpen = false

    const height = panel.scrollHeight
    panel.style.height = `${height}px`

    panel.offsetHeight

    requestAnimationFrame(() => {
      panel.style.height = "0px"
      panel.classList.remove("opacity-100")
      panel.classList.add("opacity-0")
    })
  }
}
