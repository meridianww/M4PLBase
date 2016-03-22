$(document).ready(function () {

    $("#UserLogin").submit(function (e) {
        e.preventDefault();
        var EmailID = $('#Loginemail').val().trim();
        var Password = $('#Loginpassword').val().trim();

        $.ajax({
            url: apiUrl + 'User/Login',
            //url: '/m4plapi/api/User/Login',
            type: 'GET',
            data: { 'emailId': EmailID, 'password': Password },
            contentType: 'application/json'
        }).done(function (response) {
            window.location.href = UrlRoot.homeUrl;
        }).fail(function (response) {
            alert('Login Failed');
            console.log(apiUrl);
        });
    });
});