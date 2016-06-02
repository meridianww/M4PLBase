
function changeTheme(s, e) {
    location.replace('/Home/theme?theme=' + s.GetValue());
}

$(document).ready(function () {
    $("#Language").change(
        function () {
            location.replace('/Home/ChangeLang?language=' + $(this).val());
        }
    );
});


 