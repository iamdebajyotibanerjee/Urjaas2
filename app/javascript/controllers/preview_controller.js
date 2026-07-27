// app/javascript/controllers/preview_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["editorPane", "previewPane", "iframe", "viewBtn"]

  connect() {
    // Refresh preview when turbo stream actions occur (adding/deleting blocks)
    this.refreshHandler = this.refreshIframe.bind(this)
    document.addEventListener("turbo:before-stream-render", this.refreshHandler)
  }

  disconnect() {
    document.removeEventListener("turbo:before-stream-render", this.refreshHandler)
  }

  // Reloads the preview iframe
  refreshIframe() {
    setTimeout(() => {
      if (this.hasIframeTarget) {
        this.iframeTarget.src = this.iframeTarget.src
      }
    }, 250) // Small delay ensures DB transaction completes
  }

  // Toggles between 'edit', 'split', and 'preview' view modes
  setMode(event) {
    const mode = event.currentTarget.dataset.mode

    // Update button active tabs
    this.viewBtnTargets.forEach(btn => {
      if (btn.dataset.mode === mode) {
        btn.classList.add("bg-white", "text-indigo-600", "shadow-xs")
        btn.classList.remove("text-slate-600", "hover:text-slate-900")
      } else {
        btn.classList.remove("bg-white", "text-indigo-600", "shadow-xs")
        btn.classList.add("text-slate-600", "hover:text-slate-900")
      }
    })

    // Layout switching
    if (mode === "edit") {
      this.editorPaneTarget.classList.remove("hidden", "lg:w-1/2", "w-full")
      this.editorPaneTarget.classList.add("w-full", "max-w-4xl", "mx-auto")
      this.previewPaneTarget.classList.add("hidden")
    } else if (mode === "split") {
      this.editorPaneTarget.classList.remove("hidden", "w-full", "max-w-4xl", "mx-auto")
      this.editorPaneTarget.classList.add("w-full", "lg:w-1/2")
      this.previewPaneTarget.classList.remove("hidden", "w-full")
      this.previewPaneTarget.classList.add("w-full", "lg:w-1/2")
    } else if (mode === "preview") {
      this.editorPaneTarget.classList.add("hidden")
      this.previewPaneTarget.classList.remove("hidden", "lg:w-1/2")
      this.previewPaneTarget.classList.add("w-full", "max-w-5xl", "mx-auto")
    }
  }
}