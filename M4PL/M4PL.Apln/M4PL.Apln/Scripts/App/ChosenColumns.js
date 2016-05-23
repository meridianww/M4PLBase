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