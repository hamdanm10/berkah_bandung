import { Controller } from "@hotwired/stimulus"

// data-controller="dropdown-search"
export default class extends Controller {
  static targets = ["input", "menu", "empty", "hidden"]
  static values = {
    url: String,
    selectedLabel: String,
    selectedId: String
  }

  connect() {
    this.activeIndex = -1
    this.timeout = null
    this.requestId = 0

    this.selectedValue = this.selectedLabelValue || null
    if (this.selectedIdValue) {
      this.hiddenTarget.value = this.selectedIdValue
      this.inputTarget.value = this.selectedLabelValue
    }

    this.close(false)

    this.outsideClick = this.handleOutsideClick.bind(this)
    document.addEventListener("click", this.outsideClick)

    this.inputTarget.setAttribute("aria-autocomplete", "list")
    this.inputTarget.setAttribute("aria-controls", this.menuTarget.id || "")
  }

  disconnect() {
    document.removeEventListener("click", this.outsideClick)
  }

  open() {
    this.menuTarget.classList.remove("hidden")
    this.inputTarget.setAttribute("aria-expanded", "true")
  }

  close(resetActive = true) {
    this.menuTarget.classList.add("hidden")
    this.inputTarget.setAttribute("aria-expanded", "false")
    if (resetActive) this.resetActive()
  }

  search(event) {
    const query = event.target.value.trim()
    this.resetSelection(false)

    if (query.length < 1) {
      this.clearMenu()
      return
    }

    clearTimeout(this.timeout)
    const requestId = ++this.requestId

    this.timeout = setTimeout(() => {
      this.fetchResults(query, requestId)
    }, 300)
  }

  fetchResults(query, requestId) {
    fetch(`${this.urlValue}?q=${encodeURIComponent(query)}`, {
      headers: { Accept: "application/json" }
    })
      .then(r => {
        if (!r.ok) throw new Error(`HTTP error! status: ${r.status}`)
        return r.json()
      })
      .then(items => {
        if (requestId !== this.requestId) return
        this.renderItems(items)
      })
      .catch(err => {
        console.error("Dropdown search fetch error:", err)
        this.renderItems([])
      })
  }

  renderItems(items) {
    this.menuTarget.innerHTML = ""

    if (items.length === 0) {
      this.showEmpty()
      this.open()
      return
    }

    this.hideEmpty()
    this.appendItems(items)

    this.activeIndex = 0
    this.setActive(this.items())
    this.open()
  }

  clearMenu() {
    this.menuTarget.innerHTML = ""
    this.hideEmpty()
    this.close()
  }

  appendItems(items) {
    items.forEach((item, index) => {
      const el = document.createElement("button")
      el.type = "button"
      el.dataset.value = item.value
      el.dataset.label = item.label
      el.id = `dropdown-item-${index}`
      el.className =
        "text-sm text-gray-800 w-full text-left px-3 py-2 hover:bg-gray-100"
      el.textContent = item.label
      el.addEventListener("click", () => this.choose(el))
      this.menuTarget.appendChild(el)
    })
  }

  items() {
    return Array.from(this.menuTarget.querySelectorAll("[data-value]"))
  }

  keydown(event) {
    const items = this.items()
    if (!items.length && this.isNavigationKey(event.key)) return

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
      case "Tab":
        this.cancel()
        break
    }
  }

  isNavigationKey(key) {
    return ["ArrowDown", "ArrowUp", "Enter"].includes(key)
  }

  moveActive(items, step) {
    this.activeIndex = (this.activeIndex + step + items.length) % items.length
    this.setActive(items)
  }

  setActive(items) {
    this.clearActive()
    const activeItem = items[this.activeIndex]
    if (activeItem) {
      activeItem.classList.add("bg-gray-100")
      this.inputTarget.setAttribute("aria-activedescendant", activeItem.id)
    } else {
      this.inputTarget.removeAttribute("aria-activedescendant")
    }
  }

  clearActive() {
    this.items().forEach(item => item.classList.remove("bg-gray-100"))
  }

  resetActive() {
    this.activeIndex = -1
    this.clearActive()
    this.inputTarget.removeAttribute("aria-activedescendant")
  }

  choose(item) {
    if (!item) return
    this.selectedValue = item.dataset.label
    this.inputTarget.value = this.selectedValue
    this.hiddenTarget.value = item.dataset.value
    this.close()
  }

  cancel() {
    this.requestId++
    if (this.inputTarget.value !== this.selectedValue) {
      this.clearInput()
    }
    this.close()
  }

  clearInput() {
    this.inputTarget.value = ""
    this.hiddenTarget.value = ""
    this.selectedValue = null
    this.clearMenu()
  }

  resetSelection(clearHidden = true) {
    this.selectedValue = null
    if (clearHidden) this.hiddenTarget.value = ""
  }

  showEmpty() {
    this.emptyTarget.classList.remove("hidden")
  }

  hideEmpty() {
    this.emptyTarget.classList.add("hidden")
  }

  handleOutsideClick(event) {
    if (!this.element.contains(event.target)) {
      this.cancel()
    }
  }
}
