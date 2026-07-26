import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  static values = { url: String }

  connect() {
    console.log("Sortable connected!", this.element) //Sortabel connection test
    this.sortable = new Sortable(this.element, {
      animation: 150,
      ghostClass: 'bg-light',
      onEnd: this.reorder.bind(this)
    })
  }

  reorder(event) {
    // Collect block IDs in their new DOM order
    const blockIds = Array.from(this.element.children).map(
      element => element.id.replace('page_block_', '')
    )

    // Send a PATCH request to our Rails reorder endpoint
    fetch(this.urlValue, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector("meta[name='csrf-token']").content
      },
      body: JSON.stringify({ block_ids: blockIds })
    })
  }
}