import { Controller } from "@hotwired/stimulus"
import { post } from "@rails/request.js"

export default class extends Controller {
  static targets = [ "turboFrame", "searchInput", "askInput", "buttonsContainer" ]
  static outlets = [ "dialog" ]
  static values = {
    searchUrl: String,
    askUrl: String,
  }

  dialogOutletConnected(outlet, element) {
    outlet.close()
    this.#clearTurboFrame()
  }

  reset() {
    this.dialogOutlet.close()
    this.#clearTurboFrame()

    this.#showItem(this.buttonsContainerTarget)
    this.#hideItem(this.askInputTarget)
    this.#hideItem(this.searchInputTarget)
  }

  showModalAndSubmit(event) {
    event.preventDefault()

    const form = event.target.closest("form")

    this.showModal()
    form.requestSubmit()
  }

  showModal() {
    this.dialogOutlet.open()
  }

  search(event) {
    this.#openInTurboFrame(this.searchUrlValue)

    this.#showItem(this.searchInputTarget)
    this.#hideItem(this.askInputTarget)
    this.#hideItem(this.buttonsContainerTarget)
  }

  ask(event) {
    this.#initializeConversation()
    this.#openInTurboFrame(this.askUrlValue)

    this.#showItem(this.askInputTarget)
    this.#hideItem(this.searchInputTarget)
    this.#hideItem(this.buttonsContainerTarget)
  }

  #clearTurboFrame() {
    this.turboFrameTarget.removeAttribute("src")
    this.turboFrameTarget.innerHtml = ""
  }

  #openInTurboFrame(url) {
    this.turboFrameTarget.src = url
  }

  #initializeConversation() {
    post(this.askUrlValue)
  }

  #showItem(element) {
    element.removeAttribute("hidden")

    const autofocusElement = element.querySelector("[autofocus]")
    autofocusElement?.focus()
  }

  #hideItem(element) {
    element.setAttribute("hidden", "hidden")
  }
}
