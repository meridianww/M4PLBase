(function () {

    var url = "";

    $("#frmRoles").keyup(function (event) {
        if (event.keyCode === 13) {
            $("#btnSaveRoles").click();
            event.preventDefault();
        }
    });

    $("#btnSaveRoles").click(function () {

    });

    $("#frmMenus").keyup(function (event) {
        if (event.keyCode === 13) {
            $("#btnSaveMenus").click();
            event.preventDefault();
        }
    });

    $("#btnSaveMenus").click(function () {

    });

}());