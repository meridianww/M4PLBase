function contactIndexChanged(sender) {
    
    contactID = sender.GetValue();
    if (contactID > 0)
        $('#dvContactForm').css("display", "");
    else
        $('#dvContactForm').css("display", "none");
    getOrganizationDetails();
}


if (contactID > 0)
    $('#dvContactForm').css("display", "");
else
    $('#dvContactForm').css("display", "none");
getOrganizationDetails();

function getOrganizationDetails() {
    
    $.ajax({
        url: UrlRoot.orgContactFormURL,
        data: { 'ContactID': contactID },
        type: "GET",
        dataType: "json",
        traditional: true,
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            
            if (data !== null) {
                ASPxClientControl.GetControlCollection().GetByName("OrgContact.FirstName").SetValue(data.FirstName);
                ASPxClientControl.GetControlCollection().GetByName("OrgContact.MiddleName").SetValue(data.MiddleName);
                ASPxClientControl.GetControlCollection().GetByName("OrgContact.LastName").SetValue(data.LastName);
                ASPxClientControl.GetControlCollection().GetByName("OrgContact.BusinessPhone").SetValue(data.BusinessPhone);
                ASPxClientControl.GetControlCollection().GetByName("OrgContact.MobilePhone").SetValue(data.MobilePhone);
                ASPxClientControl.GetControlCollection().GetByName("OrgContact.HomePhone").SetValue(data.HomePhone);
                ASPxClientControl.GetControlCollection().GetByName("OrgContact.Fax").SetValue(data.Fax);
                ASPxClientControl.GetControlCollection().GetByName("OrgContact.Email").SetValue(data.Email);
                ASPxClientControl.GetControlCollection().GetByName("OrgContact.Email2").SetValue(data.Email2);
                ASPxClientControl.GetControlCollection().GetByName("OrgContact.Title").SetValue(data.Title);
            } else {
                alert("Error!");
            }
        },
        error: function () {
            alert("An error has occured!!!");
        }
    });
}