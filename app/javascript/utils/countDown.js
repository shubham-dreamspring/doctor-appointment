const counter = (end_date, elems) => {
    let countDownDate = new Date(end_date).getTime();
// Update the count down every 1 second
    let x = setInterval(function () {// Get todays date and time
        let now = new Date().getTime();

        // Find the distance between now and the count down date
        let distance = countDownDate - now;

        // Time calculations for days, hours, minutes and seconds
        let days = Math.floor(distance / (1000 * 60 * 60 * 24));
        let hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
        let minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
        let seconds = Math.floor((distance % (1000 * 60)) / 1000);

        // Output the result in an element with id="demo"
        elems[0].innerText = Math.floor(days / 10);
        elems[1].innerText = days % 10;
        elems[2].innerText = Math.floor(hours / 10);
        elems[3].innerText = hours % 10;
        elems[4].innerText = Math.floor(minutes / 10);
        elems[5].innerText = minutes % 10;
        elems[6].innerText = Math.floor(seconds / 10);
        elems[7].innerText = seconds % 10;

        // If the count down is over, write some text
        if (distance < 0) {
            clearInterval(x);
        }
    }, 1000);

    return x;
}
export default counter;