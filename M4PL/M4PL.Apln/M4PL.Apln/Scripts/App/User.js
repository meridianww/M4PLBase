﻿$(document).ready(function () {

    $("#UserLogin").submit(function (e) {
        e.preventDefault();
        var EmailID = $('#Loginemail').val().trim();
        var Password = $('#Loginpassword').val().trim();
        debugger;
        //var url = apiUrl + 'User/GetLogin?emailId=' + EmailID + '&password=' + Password;
        var url = apiUrl + 'User/GetLogin';
        $.ajax({
            url: url,
            type: 'GET',
            data: { 'emailId': EmailID, 'password': Password },
            contentType: 'application/json',
            success: LoginSuccess
        }).fail(function (response) {
            alert('Login Failed');
        });
    });

    function LoginSuccess(user) {
        debugger;
        window.location.href = UrlRoot.homeUrl;
    }
});