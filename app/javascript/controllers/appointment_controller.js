import {Controller} from "@hotwired/stimulus"

export default class extends Controller {

    static targets = ['page1', 'page2', 'toggle-btn']

    page_switch() {
        let page1 = this.page1Target
        let page2 = this.page2Target

        page1.classList.add('d-none');
        page2.classList.remove('d-none')
        page2.classList.add('d-flex');

    }
}
