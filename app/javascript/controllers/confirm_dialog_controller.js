import { Controller } from "@hotwired/stimulus"

const VARIANT_CLASSES = {
  primary: "text-white bg-primary hover:bg-primary-hover",
  secondary: "text-white bg-secondary hover:bg-secondary-hover",
  dark: "text-white bg-dark hover:bg-dark-hover",
  light: "text-dark bg-light hover:bg-light-hover border border-gray-300",
  success: "text-white bg-success hover:bg-success-hover",
  danger: "text-white bg-danger hover:bg-danger-hover",
  warning: "text-white bg-warning hover:bg-warning-hover",
  info: "text-white bg-info hover:bg-info-hover"
}

export default class extends Controller {
  static targets = [
    "container",
    "title",
    "message",
    "confirmForm",
    "confirmButton",
    "confirmLabel"
  ]

  open(event) {
    const {
      confirmDialogTitle,
      confirmDialogMessage,
      confirmDialogUrl,
      confirmDialogMethod = "post",
      confirmDialogVariant = "light",
      confirmDialogLabel = "Confirm"
    } = event.currentTarget.dataset

    this.titleTarget.textContent = confirmDialogTitle
    this.messageTarget.textContent = confirmDialogMessage
    this.confirmLabelTarget.textContent = confirmDialogLabel
    this.confirmFormTarget.action = confirmDialogUrl

    this.setMethod(confirmDialogMethod)
    this.applyVariant(confirmDialogVariant)

    this.dialog.showModal()
  }

  close() {
    this.dialog.close()
  }

  setMethod(method) {
    let input = this.confirmFormTarget.querySelector('input[name="_method"]')

    if (method.toLowerCase() === "post") {
      input?.remove()
      return
    }

    if (!input) {
      input = document.createElement("input")
      input.type = "hidden"
      input.name = "_method"
      this.confirmFormTarget.appendChild(input)
    }

    input.value = method
  }

  applyVariant(variant) {
    Object.values(VARIANT_CLASSES).forEach(classes => {
      this.confirmButtonTarget.classList.remove(...classes.split(" "))
    })

    const classes = VARIANT_CLASSES[variant]
    if (classes) {
      this.confirmButtonTarget.classList.add(...classes.split(" "))
    }
  }

  get dialog() {
    return this.containerTarget.querySelector("dialog")
  }
}
