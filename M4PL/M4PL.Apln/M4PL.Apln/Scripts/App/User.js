$(document).ready(function () {

    var url = "";

    $("#frmUser").keyup(function (event) {
        if (event.keyCode === 13) {
            $("#btnSave").click();
            event.preventDefault();
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