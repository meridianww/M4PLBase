var url = "";
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
        //popupdelete.Hide();
        $('#btnPopDelclose').click();
        if (parseInt(UrlRoot.id) > 0)
            showDeletePopup(parseInt(UrlRoot.id));
        else if (grid !== null && grid !== undefined && grid.GetRowKey(grid.GetFocusedRowIndex()) > 0)
            showDeletePopup(parseInt(grid.GetRowKey(grid.GetFocusedRowIndex())));
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
}


function deleteRecord() {
    //popupdelete.Hide();
    $('#btnPopDelclose').click();
    window.location.href = url;
}

function showDeletePopup(Id) {
    url = "/" + UrlRoot.controller + "/Delete/" + Id.toString();
    //popupdelete.Show();
    $('#btnDelete').click();
}

//Document Ready
$(function () {
        $("#MyRibbon_TC_TPTCL_MinBtn").click(function () {
            if ($("body").hasClass("ribbonCollapse1")) {
                $("body").removeClass();
                $("body").addClass("ribbonCollapse");
            }
            else if ($("body").hasClass("ribbonCollapse")) {
                $("body").removeClass();
                $("body").addClass("ribbonCollapse1");
            }
       
            else if ($("body").hasclass("ribbonCollapse1" )) {
                $("body").removeclass();
                $("body").addclass("ribbonCollapse3");
            }
            else if ($("body").hasclass("ribbonCollapse1")) {
                $("body").removeclass();
                $("body").addclass("ribbonCollapse4");
            }

            $("HeaderPanel").removeClass();
            if ((min - width >= 480)) {
                $("HeaderPanel").addClass("myMenuCollapse");
            }
            else
                $("HeaderPanel").removeClass("myMenuCollapse");                   
        });      
             
    });