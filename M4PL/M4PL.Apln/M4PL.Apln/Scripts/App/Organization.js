(function () {

    var url = "";

    $("#frmOrganization").keyup(function (event) {
        if (event.keyCode === 13) {
            $("#btnSave").click();
            e.preventDefault();
        }
    });

    $("#tblOrganizations").load(function () {
        RefreshGrid();
    });

    function RefreshGrid() {
        url = apiUrl + 'Organization';
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
                $('#tblOrganizations tBody').append('<tr>');
                $('#tblOrganizations tBody').append('<td>' + data[i].OrgCode + '</td>');
                $('#tblOrganizations tBody').append('<td>' + data[i].OrgTitle + '</td>');
                $('#tblOrganizations tBody').append('<td>' + data[i].OrgGroup + '</td>');
                $('#tblOrganizations tBody').append('<td>' + data[i].Status + '</td>');
                $('#tblOrganizations tBody').append('</tr>');
            }
        }
        else {
            data = [];
            $('#tblOrganizations tBody').append('<tr><td colspan="100%">No records found</td></tr>');
        }
    }

}());