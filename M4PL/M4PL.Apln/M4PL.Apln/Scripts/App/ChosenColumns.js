function AddSelectedItems() {
    MoveSelectedItems('LstColumnName', 'LstDisplayColumnName');
}

function RemoveSelectedItems() {
    MoveSelectedItems('LstDisplayColumnName', 'LstColumnName');
}

function MoveSelectedItems(srcListBoxId, destListBoxId) {
    $.each($('#' + srcListBoxId.toString() + ' option:selected'), function () {
        $('#' + destListBoxId.toString() + '').append($("<option/>").val($(this).val()).text($(this).text()));
        $('#' + srcListBoxId.toString()).find('[value="' + $(this).val() + '"]').remove();
    });
}

function MoveSelectedItemsUp() {
    $('#LstDisplayColumnName option:selected').each(function (i, selected) {
        if (!$(this).prev().length) return false;
        $(this).insertBefore($(this).prev());
    });
}

function MoveSelectedItemsDown() {
    $($('#LstDisplayColumnName option:selected').get().reverse()).each(function (i, selected) {
        if (!$(this).next().length) return false;
        $(this).insertAfter($(this).next());
    });
}

function BindLists(lstColumnName, lstDisplayColumnName) {
    if (lstColumnName != null && lstColumnName.length > 0) {
        for (var i = 0; i < lstColumnName.length; i++) {
            $('#LstColumnName').append($("<option/>").val(lstColumnName[i].ColColumnName).text(lstColumnName[i].ColAliasName));
        }
    }

    if (lstDisplayColumnName != null && lstDisplayColumnName.length > 0) {
        for (var i = 0; i < lstDisplayColumnName.length; i++) {
            $('#LstDisplayColumnName').append($("<option/>").val(lstDisplayColumnName[i].ColColumnName).text(lstDisplayColumnName[i].ColAliasName));
        }
    }
}

function RestoreDefaults() {
    $.ajax({
        url: UrlRoot.getAllColumns,
        type: "GET",
        dataType: "json",
        data: { 'pageName': UrlRoot.controller, 'IsRestoreDefaults': true },
        traditional: true,
        contentType: "application/json; charset=utf-8",
        success: function (res) {
            if (res) {
                $('#LstColumnName, #LstDisplayColumnName').empty();
                BindLists(res.LstColumnName, res.LstDisplayColumnName);
            }
        }
    });
}

function SaveChosenColumns() {
    var SortOrder = 0, lstDisplayColumnName = [], lstColumnName = [];
    $.each($('#LstDisplayColumnName option'), function () {
        SortOrder += 1;
        lstDisplayColumnName.push({
            ColColumnName: $(this).val(),
            ColSortOrder: SortOrder,
            ColAliasName: $(this).text()
        });
    });
    SortOrder = 0;
    $.each($('#LstColumnName option'), function () {
        SortOrder += 1;
        lstColumnName.push({
            ColColumnName: $(this).val(),
            ColSortOrder: SortOrder,
            ColAliasName: $(this).text()
        });
    });

    var requestData = {
        LstColumnName: lstColumnName
        , LstDisplayColumnName: lstDisplayColumnName
        , ColPageName: UrlRoot.controller.toString()
    };

    

    $.ajax({
        url: UrlRoot.saveChosenColumns,
        type: 'POST',
        data: JSON.stringify(requestData),
        dataType: 'json',
        contentType: 'application/json; charset=utf-8',
        success: function (result) {
            //It return Partial View does not come to success.
            debugger;
            var msgType = result.MessageType;
            if (result) {
                $('#Selection').hide();
                if (msgType != null && msgType.length > 0) {
                    if (msgType === "Success" || msgType === 1) $('#btnSuccess').click();
                    else if (msgType === "Failure" || msgType === 2) $('#btnError').click();
                    else if (msgType === "Failure" || msgType === 2) $('#deletecol').click();
                    else $('#btnInfo').click();
                }
                //window.location.href = window.location.toString();
                //popupchooseCols.Hide();
            }
        },
        async: true,
        processData: false
    });
}