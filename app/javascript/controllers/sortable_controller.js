// app/javascript/controllers/sortable_controller.js
import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  static values = { url: String }

  connect() {
    this.sortable = new Sortable(this.element, {
      animation: 150,
      ghostClass: 'bg-indigo-50',
      // REMOVED handle: '.drag-handle' line here so full card is draggable
      onEnd: () => {
        this.saveOrder()
      }
    })
  }

  saveOrder() {
    const blockIds = Array.from(this.element.children).map(child => {
      return child.id.replace('page_block_', '')
    })

    fetch(this.urlValue, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ block_ids: blockIds })
    }).then(response => {
      if (response.ok) {
        window.dispatchEvent(new CustomEvent("page-builder:reordered"))
      }
    })
  }

  disconnect() {
    if (this.sortable) {
      this.sortable.destroy()
    }
  }
}