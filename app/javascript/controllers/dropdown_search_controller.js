import { Controller } from "@hotwired/stimulus"

// data-controller="dropdown-search"
export default class extends Controller {
  static targets = ["input", "menu", "empty", "hidden"]

  connect() {
    this.activeIndex = -1
    this.selectedValue = this.data.get("selectedValue") || null

    this.close()

    this.outsideClick = this.handleOutsideClick.bind(this)
    document.addEventListener("click", this.outsideClick)
  }

  disconnect() {
    document.removeEventListener("click", this.outsideClick)
  }

  open() {
    this.menuTarget.classList.remove("hidden")
    this.inputTarget.setAttribute("aria-expanded", "true")
  }

  close() {
    this.menuTarget.classList.add("hidden")
    this.inputTarget.setAttribute("aria-expanded", "false")
    this.resetActive()
  }

  search(event) {
    const query = event.target.value.toLowerCase()

    this.selectedValue = null
    this.hiddenTarget.value = ""

    const visibleItems = this.filterItems(query)
    this.toggleEmptyState(visibleItems.length, query)

    this.activeIndex = visibleItems.length ? 0 : -1
    this.setActive(visibleItems)

    this.open()
  }

  keydown(event) {
    const items = this.visibleItems()

    if (!items.length && ["ArrowDown", "ArrowUp", "Enter"].includes(event.key)) {
      return
    }

    switch (event.key) {
      case "ArrowDown":
        event.preventDefault()
        this.moveActive(items, 1)
        break

      case "ArrowUp":
        event.preventDefault()
        this.moveActive(items, -1)
        break

      case "Enter":
        event.preventDefault()
        this.choose(items[this.activeIndex] || items[0])
        break

      case "Escape":
        event.preventDefault()
        this.cancel()
        break

      case "Tab":
        this.cancel()
        break
    }
  }

  select(event) {
    this.choose(event.currentTarget)
  }

  choose(item) {
    this.selectedValue = item.dataset.label
    this.inputTarget.value = this.selectedValue
    this.hiddenTarget.value = item.dataset.value
    this.close()
  }

  handleOutsideClick(event) {
    if (!this.element.contains(event.target)) {
      this.cancel()
    }
  }

  cancel() {
    if (this.inputTarget.value !== this.selectedValue) {
      this.clearInput()
    }
    this.close()
  }

  clearInput() {
    this.inputTarget.value = ""
    this.hiddenTarget.value = ""
    this.selectedValue = null
    this.resetItems()
  }

  items() {
    return Array.from(this.menuTarget.querySelectorAll("[data-value]"))
  }

  visibleItems() {
    return this.items().filter((item) => !item.classList.contains("hidden"))
  }

  filterItems(query) {
    const visible = []

    this.items().forEach((item) => {
      const match = item.dataset.label.toLowerCase().includes(query)
      item.classList.toggle("hidden", !match)
      if (match) visible.push(item)
    })

    return visible
  }

  toggleEmptyState(visibleCount, query) {
    this.emptyTarget.classList.toggle(
      "hidden",
      visibleCount > 0 || query.length === 0
    )
  }

  moveActive(items, step) {
    this.activeIndex =
      (this.activeIndex + step + items.length) % items.length
    this.setActive(items)
  }

  setActive(items) {
    this.clearActive()
    if (this.activeIndex >= 0) {
      items[this.activeIndex]?.classList.add("bg-gray-100")
    }
  }

  clearActive() {
    this.items().forEach((item) =>
      item.classList.remove("bg-gray-100")
    )
  }

  resetActive() {
    this.activeIndex = -1
    this.clearActive()
  }

  resetItems() {
    this.items().forEach((item) =>
      item.classList.remove("hidden")
    )
    this.emptyTarget.classList.add("hidden")
  }
}
