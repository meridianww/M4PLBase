﻿(function () {

    $("#frmOrganization").keyup(function (event) {
        if (event.keyCode === 13) {
            $("#btnSave").click();
            e.preventDefault();
        }
    });

}());