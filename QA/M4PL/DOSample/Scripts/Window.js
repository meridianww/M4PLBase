$(function () {
   
});
var M4PLWindow = M4PLWindow || {};

M4PLWindow.CallBackPanel = function () {
    var params;

    var init = function (s, e, route) {
        if (route) {
            // M4PLRibbon.SetVisible((route.Action != "Dashboard"));
        }
    };

    var _onBeginCallback = function (s, e) {
    }

    var _onEndCallBack = function (s, e) {
        if (ASPxClientControl.GetControlCollection().GetByName("MainSplitter"))
            ASPxClientControl.GetControlCollection().GetByName("MainSplitter").GetPaneByName("Content").SetScrollTop(0);
        if (s.cpRibbonRoute) {
            DevExCtrl.Ribbon.DoCallBack(s.cpRibbonRoute);
            delete s.cpRibbonRoute;
        }
    }

    var _onCallbackError = function (s, e) {
        e.handled = true;
        var errorMessageFromServer = e.message;
    }

    return {
        Init: init,
        OnBeginCallback: _onBeginCallback,
        OnEndCallBack: _onEndCallBack,
        OnCallbackError: _onCallbackError,
    }
}();

M4PLWindow.DataView = function () {

    var _allowBatchEdit = {};

    var _onBeginCallback = function (s, e) {
        e.customArgs["RowKey"] = s.GetRowKey(s.GetFocusedRowIndex());
    }

    var _onInit = function (s, e) {
      
        _setCustomButtonsVisibility(s, e);
        _allowBatchEdit[s.name] = true;
    }

    var _onContextMenu = function (s, e, pageIcon, chooseColumnActionName) {
        var route = JSON.parse(e.item.name);
        route.RecordId = s.GetRowKey(e.elementIndex) && route.RecordId !== -1 ? s.GetRowKey(e.elementIndex) : 0;
        if (route.IsPopup && route.IsPopup === true) {
            DevExCtrl.LoadingPanel.Show(GlobalLoadingPanel);
            RecordPopupControl.PerformCallback({ strRoute: JSON.stringify(route) });
        } else if (ASPxClientControl.GetControlCollection().GetByName(route.OwnerCbPanel) && !ASPxClientControl.GetControlCollection().GetByName(route.OwnerCbPanel).InCallback()) {
            ASPxClientControl.GetControlCollection().GetByName(route.OwnerCbPanel).PerformCallback({ strRoute: JSON.stringify(route) });
            DevExCtrl.Ribbon.DoCallBack(route);
        }
    }

    var _setCustomButtonsVisibility = function (s, e) {
        if (ASPxClientControl.GetControlCollection().GetByName("btnSave" + s.name) && ASPxClientControl.GetControlCollection().GetByName("btnCancel" + s.name)) {
            ASPxClientControl.GetControlCollection().GetByName("btnSave" + s.name).SetEnabled(s.batchEditApi.HasChanges())
            ASPxClientControl.GetControlCollection().GetByName("btnCancel" + s.name).SetEnabled(s.batchEditApi.HasChanges())
        }
    }

    var _onBatchEditStartEditing = function (s, e, isReadOnly) {
        isReadOnly = (isReadOnly === undefined) ? false : (isReadOnly == 'True') ? true : false;
        e.cancel = (!isReadOnly) ? !_allowBatchEdit[s.name] : isReadOnly;
    }

    var _onActRoleBatchEditStartEditing = function (s, e, isReadOnly, roleId, orgId, statusIdFieldName, roleTitleFieldName) {
        isReadOnly = (isReadOnly === undefined) ? false : (isReadOnly == 'True') ? true : false;
        e.cancel = (!isReadOnly) ? !_allowBatchEdit[s.name] : isReadOnly;
        if (!e.cancel) {
            var isReadOnly = (s.GetRowKey(e.visibleIndex) == roleId);
            var statusIdEditor = s.GetEditor(statusIdFieldName);
            var roleTitleEditor = s.GetEditor(roleTitleFieldName);
            if (statusIdEditor)
                statusIdEditor.SetEnabled(!isReadOnly);
            if (roleTitleEditor)
                roleTitleEditor.SetEnabled(!isReadOnly);
        }
    }

    var _onBatchEditEndEditing = function (s, e) {
        window.setTimeout(function () { _setCustomButtonsVisibility(s, e); }, 0);
    }

    var _onCustomButtonClick = function (s, e, currentGrid) {

        if (e.buttonID && e.buttonID == "deleteButton") {
            //s.GetRowKey(e.visibleIndex) can add in all recordIds collection
            s.DeleteRow(e.visibleIndex);
            _setCustomButtonsVisibility(s, e);
        }
    }

    var _onUpdateEdit = function (grid, e, route) {
        if (grid.batchEditApi.GetDeletedRowIndices().length > 0) {
            var allIds = [];
            for (var i = 0; i < grid.batchEditApi.GetDeletedRowIndices().length; i++)
                allIds.push(grid.GetRowKey(grid.batchEditApi.GetDeletedRowIndices()[i]));

            $.ajax({
                type: "POST",
                url: route.Url + "&allRecordIds=" + String(allIds),
                success: function (response) {
                    DisplayMessageControl.PerformCallback({ strDisplayMessage: JSON.stringify(response.displayMessage) });
                },
                error: function (response) {

                }
            });

        } else {
            grid.callbackCustomArgs["UserDateTime"] = moment.now();
            grid.UpdateEdit();
        }
    }

    var _onUpdateEditWithDelete = function (grid, e, panel) {
        grid.UpdateEdit();
    }

    var _onCancelEdit = function (grid, e) {
        grid.CancelEdit();
        _setCustomButtonsVisibility(grid, e);
    }

    var _onEndCallback = function (s, e) {
        _setCustomButtonsVisibility(s, e);
        //if (s.cpBatchEditDisplayRoute)
          //  DisplayMessageControl.PerformCallback({ strDisplayMessage: JSON.stringify(s.cpBatchEditDisplayRoute) });
    }

    var _onComboBoxValueChanged = function (s, e, currentGridControl, nameFieldName) {
        if (currentGridControl && !currentGridControl.InCallback())
            currentGridControl.AutoFilterByColumn(nameFieldName || s.name, s.GetValue());
    }

    var _onDetailRowExpanding = function (s, e) {
        _allowBatchEdit[s.name] = false;
    }

    var _onDetailRowCollapsing = function (s, e) {
        _allowBatchEdit[s.name] = true;
    }

    var _onColumnResized = function (s, e) {
        if (!s.batchEditApi.HasChanges()) {
            s.PerformCallback();
        }
    }

    var _onMenuDriverBatchEditStartEditing = function (s, e, isReadOnly) {
        debugger;
        isReadOnly = (isReadOnly === undefined) ? false : (isReadOnly == 'True') ? true : false;


        var templateColumn = s.GetColumnByField("MnuRibbon");
        if (!e.rowValues.hasOwnProperty(templateColumn.index))
            return;
        var cellInfo = e.rowValues[templateColumn.index];
        MnuRibbonEdit.SetValue(cellInfo.value);
        //if (e.focusedColumn === templateColumn)
        MnuRibbonEdit.SetFocus();

        var templateColumn = s.GetColumnByField("MnuMenuItem");
        if (!e.rowValues.hasOwnProperty(templateColumn.index))
            return;
        var cellInfo = e.rowValues[templateColumn.index];
        MnuMenuItemEdit.SetValue(cellInfo.value);
        //if (e.focusedColumn === templateColumn)
        MnuMenuItemEdit.SetFocus();

        //s.batchEditApi.HasChanges()

        e.cancel = (!isReadOnly) ? !_allowBatchEdit[s.name] : isReadOnly;
    }

    var _onMenuBatchEditEndEditing = function (s, e) {
        debugger;

        var key = s.GetRowKey(e.visibleIndex)
        var templateColumn = s.GetColumnByField("MnuRibbon");
        if (!e.rowValues.hasOwnProperty(templateColumn.index))
            return;
        var cellInfo = e.rowValues[templateColumn.index];
        cellInfo.value = MnuRibbonEdit.GetValue();
        //cellInfo.text = cellInfo.text === "True" ? "False" : "True";//MnuRibbon.GetText();
        //MnuRibbonData.SetValue(MnuRibbonEdit.GetValue());

        var dataItemTemplateKey = "MnuRibbon" + key + "Data";
        if (ASPxClientControl.GetControlCollection().GetByName(dataItemTemplateKey))
            ASPxClientControl.GetControlCollection().GetByName(dataItemTemplateKey).SetValue(MnuRibbonEdit.GetValue());


        var templateColumn = s.GetColumnByField("MnuMenuItem");
        if (!e.rowValues.hasOwnProperty(templateColumn.index))
            return;
        var cellInfo = e.rowValues[templateColumn.index];
        cellInfo.value = MnuMenuItemEdit.GetValue();

        var dataItemTemplateKey = "MnuMenuItem" + key + "Data";

        //if (ASPxClientControl.GetControlCollection().GetByName(dataItemTemplateKey))
        //    ASPxClientControl.GetControlCollection().GetByName(dataItemTemplateKey).SetValue(MnuMenuItemEdit.GetValue());


        window.setTimeout(function () { _setCustomButtonsVisibility(s, e); }, 0);

        if (ASPxClientControl.GetControlCollection().GetByName(dataItemTemplateKey))
            ASPxClientControl.GetControlCollection().GetByName(dataItemTemplateKey).SetValue(MnuMenuItemEdit.GetValue());

    }

    return {
        OnInit: _onInit,
        OnContextMenu: _onContextMenu,
        OnBeginCallback: _onBeginCallback,
        OnBatchEditStartEditing: _onBatchEditStartEditing,
        OnActRoleBatchEditStartEditing: _onActRoleBatchEditStartEditing,
        OnBatchEditEndEditing: _onBatchEditEndEditing,
        OnCustomButtonClick: _onCustomButtonClick,
        OnComboBoxValueChanged: _onComboBoxValueChanged,
        OnUpdateEdit: _onUpdateEdit,
        OnUpdateEditWithDelete: _onUpdateEditWithDelete,
        OnCancelEdit: _onCancelEdit,
        OnEndCallback: _onEndCallback,
        OnDetailRowExpanding: _onDetailRowExpanding,
        OnDetailRowCollapsing: _onDetailRowCollapsing,
        OnColumnResized: _onColumnResized,
        MenuDriverBatchEditStartEditing: _onMenuDriverBatchEditStartEditing,
        MenuBatchEditEndEditing: _onMenuBatchEditEndEditing,

    };
}();