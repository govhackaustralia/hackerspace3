// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
function togglePasswordVisibility() {
    var passwordField = document.getElementById("password-field");
    var toggleIcon = document.getElementById("toggle-password-icon");
    if (passwordField.type === "password") {
        passwordField.type = "text";
        toggleIcon.classList.remove("fa-eye");
        toggleIcon.classList.add("fa-eye-slash");
    } else {
        passwordField.type = "password";
        toggleIcon.classList.remove("fa-eye-slash");
        toggleIcon.classList.add("fa-eye");
    }
}

function togglePasswordConfirmVisibility() {
    var passwordField = document.getElementById("password-confirm-field");
    var toggleIcon = document.getElementById("toggle-password-confirm-icon");
    if (passwordField.type === "password") {
        passwordField.type = "text";
        toggleIcon.classList.remove("fa-eye");
        toggleIcon.classList.add("fa-eye-slash");
    } else {
        passwordField.type = "password";
        toggleIcon.classList.remove("fa-eye-slash");
        toggleIcon.classList.add("fa-eye");
    }
}

