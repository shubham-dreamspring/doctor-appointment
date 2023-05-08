import counter from "../utils/countDown";
import {Controller} from "@hotwired/stimulus"

export default class extends Controller {

    static targets = [
        'firstDayDigit', 'secondDayDigit',
        'firstHourDigit', 'secondHourDigit',
        'firstMinDigit', 'secondMinDigit',
        'firstSecDigit', 'secondSecDigit',
        'endDateSpan'
    ]

    connect() {
        console.log('I am running')
        let elems = [
            this.firstDayDigitTarget, this.secondDayDigitTarget,
            this.firstHourDigitTarget, this.secondHourDigitTarget,
            this.firstMinDigitTarget, this.secondMinDigitTarget,
            this.firstSecDigitTarget, this.secondSecDigitTarget,
        ]
        counter(this.endDateSpanTarget.innerText, elems)
    }
}