$(document).ready(function () {
	$("#saveContact").on('click', function () {
		var contact = {};
		contact.FirtstName = $("#firstName").val().trim();
		contact.LastName = $("#lastName").val().trim();
		contact.Company = $("#company").val().trim();
		contact.JobTitle = $("#jobTitle").val().trim();
		contact.Address = $("#address").val().trim();
		contact.City = $("#city").val().trim();
		contact.State = $("#state").val().trim();
		contact.Country = $("#country").val().trim();
		contact.PostalCode = $("#postal").val().trim();

		$.ajax({
			url: apiUrl + 'Contact/SaveContact',
			type: 'POST',
			data: JSON.stringify(contact),
			contentType: 'application/json'
		}).done(function (data) {
			alert("SaveContact success");
		}).fail(function (data) {
			alert("SaveContact failed");
		});
    });
});