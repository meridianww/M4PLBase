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
            contentType: 'application/json',
            success: LoginSuccess
        //}).done(function (response) {
        //    window.location.href = UrlRoot.homeUrl;
        }).fail(function (response) {
            alert('Login Failed');
        });
    });

    function LoginSuccess(user) {
        if (user.IsValidUser)
        {
            $.ajax({
                url: 'Login/SetFormAuthentication',
                type: 'POST',
                data: JSON.stringify(user),
                contentType: 'application/json'
            }).done(function (data) {
                window.location.href = UrlRoot.homeUrl;
            });
        }
        else
        {
            alert('Invalid Email or Password');
        }
    }
});