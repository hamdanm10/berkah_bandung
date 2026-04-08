import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["audio"]

  connect() {
    if (!this.hasAudioTarget) return

    setTimeout(() => {
      this.playAudio()
    }, 100)
  }

  async playAudio() {
    try {
      await this.audioTarget.play()
    } catch (e) {
      console.warn("Autoplay blocked:", e)
    }
  }
}