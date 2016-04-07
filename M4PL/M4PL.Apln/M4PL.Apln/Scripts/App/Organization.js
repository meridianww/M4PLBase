(function () {

    var url = "";

    $("#frmOrganization").keyup(function (event) {
        if (event.keyCode === 13) {
            $("#btnSave").click();
            event.preventDefault();
        }
    });

    $("#btnSave").click(function () {

        var organizationObj = {};
        
        //organizationObj.OrgSortOrder = parseInt($("#cmbOrgSortOrder option:selected").text().trim());
        //organizationObj.OrgStatus = $("#cmbOrgStatus option:selected").text().trim();
        organizationObj.OrgCode = txtOrganizationCode.GetValue();
        organizationObj.OrgTitle = txtOrganizationTitle.GetValue();
        organizationObj.OrgGroup = txtOrganizationGroup.GetValue();
        organizationObj.OrgDesc = txtDescription.GetValue();

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