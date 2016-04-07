(function () {
    $("#frmContact").keyup(function (event) {
        if (event.keyCode === 13) {
            $("#btnSave").click();
            event.preventDefault();
        }
    });

    var disContact = {
        contact: {},
        lstContacts: []
    };

    $("#frmContact").validate({
        // Specify the validation rules
        rules: {
            FirstName: "required",
            LastName: "required"
        },

        // Specify the validation error messages
        messages: {
            FirstName: "Please enter your first name",
            LastName: "Please enter your last name"
        },
    });

    $("#btnSave").on('click', function () {
        if ($("#frmContact").valid() === false) return;
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
                $('#gvContacts').Refresh();
            },
            error: function (res) {
                alert("Some error");
            }
        });
    });
    
    function BindGrid() {
        $.ajax({
            url: webUrl,
            success: function (res) {
                $('#gvContacts').Refresh();
            },
            error: function (res) {
                alert("Some error");
            }
        });
    }

}());