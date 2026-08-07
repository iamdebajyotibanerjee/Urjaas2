// app/javascript/controllers/sortable_controller.js
import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  static values = { url: String }

  connect() {
    console.log("Sortable controller connected to element:", this.element)

    if (typeof Sortable === "undefined") {
      console.error("SortableJS is not loaded or undefined.")
      return
    }

    this.sortable = new Sortable(this.element, {
      animation: 150,
      handle: '.drag-handle',
      ghostClass: 'bg-indigo-50',
      onEnd: (evt) => {
        console.log("Drag ended, reordering blocks...")
        this.saveOrder()
      }
    })
  }

  saveOrder() {
    const blockIds = Array.from(this.element.children).map(child => {
      return child.id.replace('page_block_', '')
    })

    console.log("Sending new order:", blockIds)

    fetch(this.urlValue, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ block_ids: blockIds })
    }).then(response => {
      if (response.ok) {
        console.log("Order saved successfully.")
        window.dispatchEvent(new CustomEvent("page-builder:reordered"))
      } else {
        console.error("Failed to save block order.")
      }
    }).catch(error => {
      console.error("Fetch error while saving order:", error)
    })
  }

  disconnect() {
    if (this.sortable) {
      this.sortable.destroy()
    }
  }
}