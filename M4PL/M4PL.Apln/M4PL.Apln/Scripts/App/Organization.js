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
                $('#tblOrganizations tBody').append('<td>' + data[i].OrgStatus + '</td>');
                $('#tblOrganizations tBody').append('</tr>');
            }
        }
        else {
            data = [];
            $('#tblOrganizations tBody').append('<tr><td colspan="100%">No records found</td></tr>');
        }
    }

    $("#btnSave").click(function () {

        var organizationObj = {};
        organizationObj.OrgSortOrder = parseInt($("#cmbOrgSortOrder option:selected").text().trim());
        organizationObj.OrgStatus = $("#cmbOrgStatus option:selected").text().trim();
        organizationObj.OrgCode = $("#txtOrgCode").val().trim();
        organizationObj.OrgTitle = $("#txtOrgTitle").val().trim();
        organizationObj.OrgGroup = $("#txtOrgGroup").val().trim();
        organizationObj.OrgDesc = $("#txtOrgDesc").val().trim();

        url = apiUrl + 'Organization';
        $.ajax({
            url: url,
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(organizationObj),
            success: function (res) {
                if (res !== null && parseInt(res) > 0) {
                    alert("Organization saved successfully");
                    GoBack();
                }
                else {
                    alert("Organization not saved. Please check inputs!");
                }
            },
            error: function (res) {
                alert("some error");
            }
        });

    });

}());