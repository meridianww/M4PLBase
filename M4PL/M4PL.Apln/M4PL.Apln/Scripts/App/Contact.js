(function () {
    $("#frmContact").keyup(function (event) {
        if (event.keyCode == 13) {
            $("#btnSave").click();
            e.preventDefault();
        }
    });

    var disContact = {
        contact: {},
        lstContacts: []
    };

    $("#btnSave").on('click', function () {
        var contactObj = {};
        contactObj.FirstName = $("#txtFirstName").val().trim();
        contactObj.LastName = $("#txtLastName").val().trim();
        contactObj.Company = $("#txtCompany").val().trim();
        contactObj.JobTitle = $("#txtJobTitle").val().trim();
        contactObj.Address = $("#txtAddress").val().trim();
        contactObj.City = $("#txtCity").val().trim();
        contactObj.State = $("#txtState").val().trim();
        contactObj.Country = $("#txtCountry").val().trim();
        contactObj.PostalCode = $("#txtPostalCode").val().trim();
        contactObj.BusinessPhone = $("#txtBusinessPhone").val().trim();
        contactObj.MobilePhone = $("#txtMobilePhone").val().trim();
        contactObj.Email = $("#txtEmail").val().trim();
        contactObj.HomePhone = $("#txtHomePhone").val().trim();
        contactObj.Fax = $("#txtFax").val().trim();
        contactObj.Notes = $("#txtNotes").val().trim();

        disContact.contact = contactObj;

        $.ajax({
            url: apiUrl + 'Contact/SaveContact',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(contactObj),
            success: function (res) {
                alert("Contact saved successfully");
                RefreshGrid();
            },
            error: function (res) {
                RefreshGrid();
            }
        });
    });

    RefreshGrid();

    function RefreshGrid() {
        $.ajax({
            url: apiUrl + 'Contact',
            type: 'GET',
            contentType: 'application/json',
            success: function (res) {
                BindGrid(res);
            },
            error: function (res) {
                alert("Some error");
            }
        });
    }

    function BindGrid(data) {
        debugger;
        disContact.lstContacts = data;
        var str = '<table class="table table-bordered"><thead><tr><th>Job Title</th><th>Full Name</th><th>Company</th><th>Email</th><th>Mobile</th><th>Business</th></tr></thead><tbody>';
        if (data != null && data.length > 0) {
            for (var i = (data.length - 1) ; i >= 0; i--) {
                str += '<tr>';
                str += '<td>' + data[i].JobTitle + '</td>';
                str += '<td>' + data[i].FullName + '</td>';
                str += '<td>' + data[i].Company + '</td>';
                str += '<td>' + data[i].Email + '</td>';
                str += '<td>' + data[i].MobilePhone + '</td>';
                str += '<td>' + data[i].BusinessPhone + '</td>';
                str += '</tr>';
            }
        }
        str += '</tbody></table>';

        $('#dvGrid').html(str);
    }

}());