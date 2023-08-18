import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ['paymentProcessingScreen', 'successScreen']

    connect() {
        setTimeout(() => {
            this.paymentProcessingScreenTarget.classList.remove('d-flex')
            this.paymentProcessingScreenTarget.classList.add('d-none')
            this.successScreenTarget.classList.remove('d-none')
            this.successScreenTarget.classList.add('d-block')
        }, 2000)
    }
}
