function NextPrevious(s, e) {
    var options = 0;
    if (parseInt(UrlRoot.id) > 0 && (e.item.name.toLowerCase() === "itmprev" || e.item.name.toLowerCase() === "itmnext" || e.item.name.toLowerCase() === "itmfirst" || e.item.name.toLowerCase() === "itmlast")) {
        if (e.item.name.toLowerCase() === "itmnext")
            options = 1;
        else if (e.item.name.toLowerCase() === "itmfirst")
            options = 2;
        else if (e.item.name.toLowerCase() === "itmlast")
            options = 3;

        $.ajax({
            url: UrlRoot.nextPrevious,
            type: "GET",
            dataType: "json",
            data: { 'pageName': UrlRoot.controller, 'id': UrlRoot.id, 'options': options },
            traditional: true,
            contentType: "application/json; charset=utf-8",
            success: function (res) {
                if (res > 0) {
                    window.location.href = '/' + UrlRoot.controller + '/Edit/' + res.toString();
                }
            }
        });
    }
}