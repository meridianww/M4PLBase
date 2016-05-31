function onCommandExecuted(s, e) {
    var cmdName = e.item.name;
    cmdText = (e.item.text !== null && e.item.text !== '' && e.item.text.length > 0) ? e.item.text : '';
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
        if (parseInt(id) > 0 && confirm('Do you really want to delete this record?'))
            window.location.href = UrlRoot.deleteURL;
    }
    else if (cmdName.toLowerCase() === "save") {
        cmdName = '';
        if (action.toLowerCase() === "create" || action.toLowerCase() === "edit")
            $('#frm' + controller.toString()).submit();
        else if (controller.toLowerCase() === "allsettings" && action.toLowerCase() === "savealiascolumn")
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
        //  alert('dd');
        cmdName = '';
        if (grid !== null && grid !== undefined) {
            focussedkeyId = grid.GetRowKey(grid.GetFocusedRowIndex());
            UrlRoot.DeleteURL = "/" + controller + "/Delete/" + grid.GetRowKey(grid.GetFocusedRowIndex())
            DeleteContact(UrlRoot.DeleteURL);
        }
    }
}
