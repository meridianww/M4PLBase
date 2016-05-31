function onCommandExecuted(s, e) {
    var cmdName = e.item.name;
    var cmdText = (e.item.text !== null && e.item.text !== '' && e.item.text.length > 0) ? e.item.text : '';
    cmdText = ((cmdText === '' || cmdText.length === 0) && (e.parameter !== null && e.parameter.toString() !== '' && e.parameter.toString().length > 0)) ? e.parameter.toString() : '';

    if (cmdName.toLowerCase() === "new") {
        cmdName = '';
        window.location.href = UrlRoot.createURL;
    }
    else if (cmdName.toLowerCase() === "formview") {
        cmdName = '';
        if (grid !== null && grid !== undefined) {
            window.location.href = UrlRoot.editURL + '/' + grid.GetRowKey(grid.GetFocusedRowIndex());
        }
    }
    else if (cmdName.toLowerCase() === "datasheetview") {
        cmdName = '';
        window.location.href = UrlRoot.indexURL;
    }
    else if (cmdName.toLowerCase() === "refreshall" || cmdName.toLowerCase() === "removesort") {
        cmdName = '';
        window.location.href = window.location.toString();
    }
    else if (cmdName.toLowerCase() === "delete") {
        cmdName = '';
        if (parseInt(UrlRoot.id) > 0 && confirm('Do you really want to delete this record?'))
            window.location.href = UrlRoot.deleteURL;
    }
    else if (cmdName.toLowerCase() === "save") {
        cmdName = '';
        if (UrlRoot.action.toLowerCase() === "create" || UrlRoot.action.toLowerCase() === "edit")
            $('#frm' + UrlRoot.controller.toString()).submit();
        else if (UrlRoot.controller.toLowerCase() === "allsettings" && UrlRoot.action.toLowerCase() === "savealiascolumn")
            gvColumnAliases.UpdateEdit();
    }
    else if (cmdName.toLowerCase() === "advanced") {
        cmdName = '';
        if (grid !== null && grid !== undefined) {
            grid.SetFilterEnabled(true);
            grid.ShowFilterControl();
            grid.ApplyFilter();
        }
    }
    else if (cmdName.toLowerCase() === "clearfilter") {
        cmdName = '';
        if (grid !== null && grid !== undefined) {
            grid.SetFilterEnabled(false);
            grid.CloseFilterControl();
            grid.ClearFilter();
            grid.Refresh();
        }
    }
    else if (cmdName.toLowerCase() === "togglefilter") {
        cmdName = '';
        $.ajax({
            url: UrlRoot.setGridProperties,
            type: "GET",
            dataType: "json",
            traditional: true,
            contentType: "application/json; charset=utf-8",
            success: function (res) {
                if (res && grid !== null && grid !== undefined) {
                    grid.PerformCallback();
                }
            }
        });
    }
    else if (cmdName.toLowerCase() === "choosecolumns") {
        cmdName = '';
        popupchooseCols.Hide();
        if (grid !== null && grid !== undefined) {
            $.ajax({
                url: UrlRoot.getAllColumns,
                type: "GET",
                dataType: "json",
                data: { 'pageName': UrlRoot.controller },
                traditional: true,
                contentType: "application/json; charset=utf-8",
                success: function (res) {
                    if (res) {
                        popupchooseCols.Show();
                        $('#LstColumnName, #LstDisplayColumnName').html("");
                        BindLists(res.LstColumnName, res.LstDisplayColumnName);
                    }
                }
            });
        }
    }
    else if (cmdName.toLowerCase() === "newbutton") {
        cmdName = '';
        window.location.href = UrlRoot.saveAliasColumn;
    }
    else if (cmdName.toLowerCase() === "deletecolumns") {
        cmdName = '';
        if (grid !== null && grid !== undefined) {

            focussedkeyId = grid.GetRowKey(grid.GetFocusedRowIndex());
            UrlRoot.deleteURL = "/" + UrlRoot.controller + "/Delete/" + grid.GetRowKey(grid.GetFocusedRowIndex())
            DeleteContact(UrlRoot.deleteURL);
        }
    }
}

var URL = "";
$(document).on('click', '#btnOk_CD', function () {
    $('#popupdelete_PW-1').hide();
    $.ajax({
        url: URL,
        type: "GET",
        dataType: "json",
        //data: { 'pageName': controller },
        traditional: true,
        contentType: "application/json; charset=utf-8",
        success: function (res) {
            debugger;
            if (res) {
                if (res.MessageType == 1)
                    $('#btnSuccess').click();
                else if (res.MessageType == 2)
                    $('#btnError').click();
                else
                    $('#btnInfo').click();

            }
        }
    });
});

function DeleteContact(id) {
    debugger;
    URL = id;
    $('#btnOk_CD').trigger('click');
}



