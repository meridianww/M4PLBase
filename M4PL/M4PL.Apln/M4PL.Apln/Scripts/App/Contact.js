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
            txtFirstName: "required",
            txtLastName: "required"
        },

        // Specify the validation error messages
        messages: {
            txtFirstName: "Please enter your first name",
            txtLastName: "Please enter your last name"
        },
    });

    $("#btnSave").on('click', function () {

        if ($("#frmContact").valid() === false) return;
        var contactObj = {};
        contactObj.FirstName = txtFirstName.GetValue().trim();
        contactObj.LastName = txtLastName.GetValue().trim();;
        contactObj.Company = txtCompany.GetValue().trim();;
        contactObj.JobTitle = txtJobtitle.GetValue().trim();;
        contactObj.Address = txtAddress.GetValue().trim();;
        contactObj.City = txtCity.GetValue().trim();;
        contactObj.State = txtState.GetValue().trim();;
        contactObj.Country = txtCountry.GetValue().trim();;
        contactObj.PostalCode = txtPostalcode.GetValue().trim();;
        contactObj.BusinessPhone = txtBusinessphone.GetValue().trim();;
        contactObj.MobilePhone = txtMobilephone.GetValue().trim();;
        contactObj.Email = txtEmailaddress1.GetValue().trim();;
        contactObj.Email = txtEmailaddress2.GetValue().trim();;
        contactObj.HomePhone = txtHomephone.GetValue().trim();;
        contactObj.Fax = txtFaxnumber.GetValue().trim();;
        contactObj.Notes = txtNotes.GetValue().trim();;

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