import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="turbomodal"
export default class extends Controller {
  connect() {
  }
  submitEnd(e){
    if (e.detail.success){
      toggleModal('modal-id')
    }
  }
  hideModal(){
    this.element.remove()
  }
}
