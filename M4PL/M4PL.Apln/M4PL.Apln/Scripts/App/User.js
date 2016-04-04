$(document).ready(function () {

    var url = "";

    $("#UserLogin").submit(function (e) {
        e.preventDefault();
        var EmailID = $('#Loginemail').val().trim();
        var Password = $('#Loginpassword').val().trim();
        //var url = apiUrl + 'User/GetLogin?emailId=' + EmailID + '&password=' + Password;
        url = apiUrl + 'User/GetLogin';
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
        window.location.href = UrlRoot.homeUrl;
    }

    function RefreshGrid() {
        url = apiUrl + 'User';
        $.ajax({
            url: url,
            type: 'GET',
            contentType: 'application/json'
        }).success(function (response) {
            BindGrid(response);
        }).error(function (response) {
            alert('Some error');
        });
    }

    function BindGrid(data) {
        if (data !== null && data.length > 0) {
            for (var i = (data.length - 1) ; i >= 0; i--) {
                $('#tblUsers tBody').append('<tr>');
                $('#tblUsers tBody').append('<td>' + data[i].SysScreenName + '</td>');
                $('#tblUsers tBody').append('<td>' + data[i].ConFullName + '</td>');
                $('#tblUsers tBody').append('<td>' + data[i].Description + '</td>');
                $('#tblUsers tBody').append('</tr>');
            }
        }
        else {
            data = [];
            $('#tblUsers tBody').append('<tr><td colspan="100%">No records found</td></tr>');
        }
    }

    $("#tblUsers").load(function () {
        RefreshGrid();
    });

    $("#frmUser").keyup(function (event) {
        if (event.keyCode === 13) {
            $("#btnSave").click();
            e.preventDefault();
        }
    });

    $("#btnSave").click(function () {
        
        var userObj = {};
        userObj.SysUserContactID = parseInt($("#cmbContacts option:selected").val().trim());
        userObj.SysStatusAccount = parseInt($("#cmbStatus option:selected").val().trim());
        userObj.SysScreenName = $("#txtScreenName").val().trim();
        userObj.SysPassword = $("#txtPassword").val().trim();
        userObj.SysComments = $("#txtComments").val().trim();
        
        url = apiUrl + 'User';
        $.ajax({
            url: url,
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(userObj),
            success: function (res) {
                if (res !== null && parseInt(res) > 0) {
                    alert("User saved successfully");
                    GoBack();
                }
                else {
                    alert("User not saved. Please check inputs!");
                }
            },
            error: function (res) {
                alert("some error");
            }
        });
        
    });

    function FillComboboxes() {
        url = apiUrl + 'Contact';
        var cmb;
        $.getJSON(url, function (data) {
            cmb = $("#cmbContacts");
            cmb.append(new Option("--- Select Contact ---", -1));
            if (data !== null && data.length > 0) {
                $.each(data, function () {
                    cmb.append(new Option((this.FullName !== null && this.FullName !== undefined) ? this.FullName.trim() : "", this.ContactID));
                });
            }
        })
        .then(function () {
            url = apiUrl + 'User/GetAllUserAccountStatus';
            $.getJSON(url, function (data) {
                cmb = $("#cmbStatus");
                cmb.append(new Option("--- Select Status ---", -1));
                if (data !== null && data.length > 0) {
                    $.each(data, function () {
                        cmb.append(new Option((this.Description !== null && this.Description !== undefined) ? this.Description.trim() : "", this.Id));
                    });
                }
            });
        });
    }

    $("#frmUser").load(function () {
        FillComboboxes();
    });

});