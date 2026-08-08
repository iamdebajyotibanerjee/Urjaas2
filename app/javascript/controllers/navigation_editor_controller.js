// app/javascript/controllers/navigation_editor_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "container" ]

  addLink(event) {
    event.preventDefault()
    const row = document.createElement("div")
    row.className = "flex items-center gap-2 link-row"
    row.innerHTML = `
      <input type="text" name="page_block[content_data][nav_links][][label]" placeholder="Label" class="w-1/2 px-2.5 py-1.5 text-xs rounded-md border border-slate-300">
      <input type="text" name="page_block[content_data][nav_links][][url]" placeholder="URL" class="w-1/2 px-2.5 py-1.5 text-xs font-mono rounded-md border border-slate-300">
      <button type="button" data-action="click->navigation-editor#removeLink" class="text-slate-400 hover:text-red-500 px-1 text-sm font-bold">&times;</button>
    `
    this.containerTarget.appendChild(row)
  }

  removeLink(event) {
    event.preventDefault()
    event.target.closest(".link-row").remove()
  }
}