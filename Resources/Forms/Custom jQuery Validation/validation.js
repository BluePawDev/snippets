/* jQuery Validate */
<script src="https://ajax.aspnetcdn.com/ajax/jquery.validate/1.16.0/jquery.validate.min.js"></script>
<script src="https://ajax.aspnetcdn.com/ajax/jquery.validate/1.16.0/additional-methods.min.js"></script>


$('.invalid-feedback').hide();

/* On input fields remove the 'required' parameter and the title="" as they are not needed */
$('##form-register').validate({
    // errorContainer: container,
    // errorLabelContainer: $("ol", container),
    // wrapper: 'li',
    rules: {
        firstName: {
            required: true,
            maxlength: 250
        },
        lastName: {
            required: true,
            maxlength: 250
        },
        title: {
            required: true,
            maxlength: 250
        },
        email: {
            required: true,
            email: true,
            maxlength: 500
        },

        // Regex pattern for requiring: one uppercase letter, one lowercase letter, and one number or one special character
        password: {
            required: true,
            minlength: 8,
            maxlength: 30,
            pattern: "(?=.*[!@##$%^&*_0-9])(?=.*[a-z])(?=.*[A-Z]).{8,}"
        },
        confirmPassword: {
            required: true,
            equalTo: "##password",
            maxlength: 30
        },
        regionId: "required",
        propertyId: "required",
        accountNumber: {
            required: true,
            maxlength: 16,
            pattern: "^(601599)([0-9]{10})"
        }
    },
    messages: {
        firstName: {
            required: "First Name is required",
            maxlength: "First Name cannot be longer than 250 characters"
        },
        lastName: {
            required: "Last Name is required",
            maxlength: "Last Name cannot be longer than 250 characters"
        },
        title: {
            required: "Title  is required",
            maxlength: "Title cannot be longer than 250 characters"
        },
        email: {
            required: "Email is required",
            email: "Not a valid email address",
            maxlength: "Email cannot be longer than 500 characters"
        },
        password: {
            required: "Password is required (at least 8 characters, 1 upper, 1 lower, AND 1 number OR special character)",
            minlength: "Must be at least 8 characters, 1 upper, 1 lower, AND 1 number OR special character",
            maxlength: "Password cannot be longer than 30 characters",
            pattern: "Must be at least 8 characters, 1 upper, 1 lower, AND 1 number OR special character"
        },
        confirmPassword: {
            required: "Confirm Password is required",
            equalTo: "Password and Confirm Password do not match",
            maxlength: "Confirm Password cannot be longer than 30 characters"
        },
        regionId: "Regional Director is required",
        propertyId: "Property Code is required",
        accountNumber: {
            required: "Radisson Rewards Number is required",
            maxlength: "Radisson Rewards Numbers are 16 digits",
            pattern: "Radisson Rewards Numbers begin with 601599 and are 16 digits"
        }
    },
    errorPlacement: function(error, element) {
        var errorDiv = element.parent().find('.invalid-feedback');
        var fieldMsg = element.parent().find('.field-message');
        if (!typeof fieldMsg === 'undefined' || fieldMsg.length != 0) {
            fieldMsg.hide();
        }
        errorDiv.html(error[0].innerHTML);
        errorDiv.show();
        errorDiv.parent().parent().css("margin-bottom", "0px");
    },
    highlight: function(element) {
        $(element).parents('.form-group').addClass('has-error');
    },
    unhighlight: function(element) {
        $(element).parents('.form-group').removeClass('has-error');
        $(element).parent().find('.invalid-feedback').html("");
        $(element).parents('.form-group').removeAttr("style");
    },
    errorElement: 'div',
    errorClass: 'validation-error-message help-block form-helper bold'
});