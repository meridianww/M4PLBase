(function () {
    function readURL(input) {

        if (input.files && input.files[0]) {
            var reader = new FileReader();

            reader.onload = function (e) {
                $('#imgPreview').attr('src', e.target.result);
            }

            reader.readAsDataURL(input.files[0]);
        }
    }

    $("#file-input").change(function () {
        readURL(this);
    });

    $("#file-input").css("display", "none");


})();



function DeleteContact(id) {
    
    $('#btnOk_CD').on('click', function () {

        $.ajax({
            url: id,
            type: "GET",
            dataType: "json",
            //data: { 'pageName': controller },
            traditional: true,
            contentType: "application/json; charset=utf-8",
            success: function (res) {
                if (res) {
                    popupdelete.hide();
                }
            }
        });
    });


}





