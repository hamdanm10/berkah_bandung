import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["audio", "playIcon", "pauseIcon"]

  toggle() {
    if (this.audioTarget.paused) {
      this.play()
    } else {
      this.pause()
    }
  }

  play() {
    document.querySelectorAll("[data-controller='audio-player']").forEach(el => {
      const controller = this.application.getControllerForElementAndIdentifier(el, "audio-player")
      if (controller && controller !== this) {
        controller.forcePause()
      }
    })

    this.audioTarget.play()
    this.showPause()
  }

  pause() {
    this.audioTarget.pause()
    this.showPlay()
  }

  forcePause() {
    this.audioTarget.pause()
    this.showPlay()
  }

  reset() {
    this.showPlay()
  }

  showPlay() {
    this.playIconTarget.classList.remove("hidden")
    this.pauseIconTarget.classList.add("hidden")
  }

  showPause() {
    this.playIconTarget.classList.add("hidden")
    this.pauseIconTarget.classList.remove("hidden")
  }
}