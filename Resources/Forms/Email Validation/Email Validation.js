

// regex evaluation of valid email address

$('.emailAddress').on('blur', function() {
    let email = $('.emailAddress').val();
    let regexEmail = RegExp(/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/);
    if (email == "" || regexEmail.test(email) == false) {
        // Do something...
    } else {
        // Do something else...
    }
})