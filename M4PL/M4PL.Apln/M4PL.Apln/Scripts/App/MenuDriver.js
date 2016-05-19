(function () {
    
    $('#dvRibbon, input[type="file"]').css("display", "none");

    function readURL(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            reader.onload = function (e) {
                $('#imgPreview' + input.name.substring(2).toString()).attr('src', e.target.result);
            }
            reader.readAsDataURL(input.files[0]);
        }
    }

    $('input[type="file"]').change(function () {
        readURL(this);
    });

})();



