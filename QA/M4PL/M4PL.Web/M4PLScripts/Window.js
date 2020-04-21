/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 Window.js
//Purpose:                                      For implementing M4PLWindow client side logic throughout the application
//====================================================================================================================================================*/

$(function () {
    M4PLWindow.FormView.init();
});
var M4PLWindow = M4PLWindow || {};
M4PLWindow.FormViewHasChanges = false;
M4PLWindow.PopupFormViewHasChanges = false;
M4PLWindow.SubPopupFormViewHasChanges = false;
M4PLWindow.IsFromConfirmSaveClick = false;
M4PLWindow.PopupDataViewHasChanges = {};
M4PLWindow.DataViewsHaveChanges = {};
M4PLWindow.SubDataViewsHaveChanges = {};

M4PLWindow.CallBackPanel = function () {
    var params;
    var hasChanges = false;
    var init = function (s, e, route) {
        ASPxClientUtils.AttachEventToElement(
            s.GetMainElement(),
            "keydown",
            function (evt) {
                if (event.keyCode == 8 || event.keyCode == 32 || (event.keyCode >= 48 && event.keyCode <= 57) || (event.keyCode >= 65 && event.keyCode <= 90))
                    hasChanges = true;
            });
    };

    var _onBeginCallback = function (s, e) {
        //TODO: If haschanges ===true somehow stop this callback and after confirmation message set haschanges =false
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

    var _onBeginCallback = function (s, e, gridName) {
        if (s && s.name)
            M4PLCommon.Control.UpdateDataViewHasChanges(s.name, false);
        e.customArgs["RowKey"] = s.GetRowKey(s.GetFocusedRowIndex());
    }

    var _onInit = function (s, e, isChildExpanded, clearFilterManually) {

        if (clearFilterManually && clearFilterManually == "True") {
            s.ClearFilter();
        }
        if (s.cpCustomerDefaultActiveFilter && s.cpCustomerDefaultActiveFilter.length > 0 && s.name === 'JobGridView') {
            s.ApplyFilter(s.cpCustomerDefaultActiveFilter);
        }


        ASPxClientUtils.AttachEventToElement(document, "scroll", function (evt) {
            if (s.GetFilterRowMenu() !== undefined && s.GetFilterRowMenu() !== "undefined")
                s.GetFilterRowMenu().SetVisible(false);
        });

        var allowBatchEdit = (isChildExpanded) ? (isChildExpanded == "False") ? true : false : true;
        M4PLWindow.FormView.ClearErrorMessages();
        _setCustomButtonsVisibility(s, e);
        _allowBatchEdit[s.name] = allowBatchEdit;
    }

    var _onContextMenu = function (s, e, pageIcon, chooseColumnActionName, copyActionName) {
        var route = JSON.parse(e.item.name);
        var isDataView = false;
        isDataView = route.Action === "FormView" ? false : true
        if (route) {
            route.RecordId = s.GetRowKey(e.elementIndex) && route.RecordId !== -1 ? s.GetRowKey(e.elementIndex) : 0;
            if (s.name === "JobGatewayGridView" && route.Action === "ContactCardFormView") {
                //if (ASPxClientControl.GetControlCollection().GetByName("pnlJobDetail")) {
                //    var roundPanel = ASPxClientControl.GetControlCollection().GetByName("pnlJobDetail");

                //}

                route.RecordId = 0;
            }
            if (route.Action == copyActionName) {
                $.ajax({
                    type: "GET",
                    url: route.Area + "/" + route.Controller + "/" + route.Action + "?strRoute=" + JSON.stringify(route)
                        + "&gridName = '' &filterId = 0 &isJobParentEntity = false &isDataView=" + isDataView,
                });
            } else if (!M4PLCommon.CheckHasChanges.CheckDataChanges(s.name)) {
                if ((route.IsPopup && route.IsPopup === true) || route.Action == chooseColumnActionName) {
                    if (route.Action == "ToggleFilter") {
                        DevExCtrl.Ribbon.OnFilterClicked(s, e, route, route.OwnerCbPanel, '');
                    }
                    else {
                        DevExCtrl.LoadingPanel.Show(GlobalLoadingPanel);
                        RecordPopupControl.PerformCallback({ strRoute: JSON.stringify(route) });
                    }
                } else if (ASPxClientControl.GetControlCollection().GetByName(route.OwnerCbPanel) && !ASPxClientControl.GetControlCollection().GetByName(route.OwnerCbPanel).InCallback()) {
                    ASPxClientControl.GetControlCollection().GetByName(route.OwnerCbPanel).PerformCallback({ strRoute: JSON.stringify(route) });
                    DevExCtrl.Ribbon.DoCallBack(route);
                }
            } else {
                M4PLCommon.CallerNameAndParameters = { "Caller": _onContextMenu, "Parameters": [s, e, pageIcon, chooseColumnActionName, copyActionName] };
                M4PLCommon.CheckHasChanges.ShowConfirmation();
            }
        }
    }

    var _setCustomButtonsVisibility = function (s, e) {
        if (ASPxClientControl.GetControlCollection().GetByName("btnSave" + s.name) && ASPxClientControl.GetControlCollection().GetByName("btnCancel" + s.name)) {
            M4PLCommon.Control.UpdateDataViewHasChanges(s.name, s.batchEditApi.HasChanges());
            ASPxClientControl.GetControlCollection().GetByName("btnSave" + s.name).SetEnabled(s.batchEditApi.HasChanges())
            ASPxClientControl.GetControlCollection().GetByName("btnCancel" + s.name).SetEnabled(s.batchEditApi.HasChanges())

            if (!s.batchEditApi.HasChanges()) {
                $("#" + "btnSave" + s.name).addClass("noHover");
                $("#" + "btnCancel" + s.name).addClass("noHover");
            } else {
                $("#" + "btnSave" + s.name).removeClass("noHover");
                $("#" + "btnCancel" + s.name).removeClass("noHover");
            }

        }
    }


    var _onBatchEditStartEditing = function (s, e, isReadOnly, disableEditor, fieldToCheck, hiddenFieldName) {
        isReadOnly = (isReadOnly === undefined) ? false : (isReadOnly == 'True') ? true : false;
        e.cancel = (!isReadOnly) ? !_allowBatchEdit[s.name] : isReadOnly;
        if (!e.cancel && disableEditor) {
            if ((e.focusedColumn.fieldName == fieldToCheck) && s.batchEditApi.GetCellValue(s.GetFocusedRowIndex(), hiddenFieldName) && (s.batchEditApi.GetCellValue(s.GetFocusedRowIndex(), hiddenFieldName) > 0)) {
                var editor = s.GetEditor(fieldToCheck);
                if (editor)
                    editor.SetEnabled(false);
            } else {
                var editor = s.GetEditor(fieldToCheck);
                if (editor)
                    editor.SetEnabled(true);
            }
        }
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

    var _onHavingChildCustomButtonClick = function (s, e, isReadOnly) {
        if (e.buttonID && e.buttonID == "deleteButton") {
            isReadOnly = (isReadOnly === undefined) ? false : (isReadOnly == 'True') ? true : false;
            e.cancel = (!isReadOnly) ? !_allowBatchEdit[s.name] : isReadOnly;
            if (!e.cancel && !isReadOnly) {
                s.DeleteRow(e.visibleIndex);
                _setCustomButtonsVisibility(s, e);
            }
            else {
            }
        }
    }

    var _onUpdateEdit = function (grid, e, route) {
        if (grid.batchEditApi.GetDeletedRowIndices().length > 0) {
            var allIds = [];
            for (var i = 0; i < grid.batchEditApi.GetDeletedRowIndices().length; i++)
                allIds.push(grid.GetRowKey(grid.batchEditApi.GetDeletedRowIndices()[i]));

            $.ajax({
                type: "POST",
                data: { 'allRecordIds': String(allIds), 'gridName': name },
                url: route.Url, // + "&allRecordIds=" + String(allIds) + "&gridName=" + grid.name,
                success: function (response) {
                    DisplayMessageControl.PerformCallback({ strDisplayMessage: JSON.stringify(response.displayMessage) });
                },
                error: function (response) {
                    console.log(response);
                }
            });

        } else {
            grid.callbackCustomArgs["UserDateTime"] = moment.now();
            grid.UpdateEdit();
        }

        if (route.EntityName === 'Organization') {
            window.setTimeout(function () { UserHeaderCbPanel.PerformCallback(); }, 1000);
        }
    }

    var _onUpdateEditWithDelete = function (grid, e, panel) {
        //if (grid.cpRowHashes) {
        //    grid.callbackCustomArgs["RowHashes"] = grid.cpRowHashes;
        //}
        grid.UpdateEdit();
    }

    var _onCancelEdit = function (grid, e) {
        M4PLWindow.PopupDataViewHasChanges[grid.name] = false;
        M4PLWindow.DataViewsHaveChanges[grid.name] = false;
        if (!M4PLCommon.CheckHasChanges.CheckDataChanges(grid.name)) {
            grid.CancelEdit();
            _setCustomButtonsVisibility(grid, e);
        } else {
            M4PLCommon.CallerNameAndParameters = { "Caller": _onCancelEdit, "Parameters": [grid, e] };
            M4PLCommon.CheckHasChanges.ShowConfirmation();
        }
    }

    var _onEndCallback = function (s, e) {
        _setCustomButtonsVisibility(s, e);
        if (s.cpBatchEditDisplayRoute) {
            if (s.name === "JobGatewayGridView") {
                var gatewayStatusctrl = ASPxClientControl.GetControlCollection().GetByName('JobGatewayStatus');
                if (gatewayStatusctrl != null && s.cpBatchEditDisplayRoute.GatewayStatusCode != null &&
                    s.cpBatchEditDisplayRoute.GatewayStatusCode != undefined) {
                    gatewayStatusctrl.SetValue(s.cpBatchEditDisplayRoute.GatewayStatusCode);
                }
                var gatewayJobOriginDateTimeActualctrl = ASPxClientControl.GetControlCollection().GetByName('JobOriginDateTimeActual');
                if (gatewayJobOriginDateTimeActualctrl != null && s.cpBatchEditDisplayRoute.JobOriginActual != null &&
                    s.cpBatchEditDisplayRoute.JobOriginActual != undefined) {
                    //gatewayJobOriginDateTimeActualctrl.SetValue(FromJsonToDate(s.cpBatchEditDisplayRoute.JobOriginActual));
                    gatewayJobOriginDateTimeActualctrl.SetValue(new Date(s.cpBatchEditDisplayRoute.JobOriginActual));
                }
            }

            DisplayMessageControl.PerformCallback({ strDisplayMessage: JSON.stringify(s.cpBatchEditDisplayRoute) });
            if (M4PLWindow.IsFromConfirmSaveClick) {
                M4PLWindow.IsFromConfirmSaveClick = false;
                M4PLCommon.CheckHasChanges.RedirectToClickedItem();
            }
        }
    }

    var _onComboBoxValueChanged = function (s, e, currentGridControl, nameFieldName) {
        if (ASPxClientControl.GetControlCollection().GetByName("ValFieldNameEdit_Filter") != null)
            ASPxClientControl.GetControlCollection().GetByName("ValFieldNameEdit_Filter").SetValue(s.GetCurrentText());

        if (currentGridControl && !currentGridControl.InCallback())
            currentGridControl.AutoFilterByColumn(nameFieldName || s.name, s.GetValue());
    }

    var _onCompanyComboBoxValueChanged = function (s, e, selectedId) {
        var selectedCompanyId = null;
        var selectedCompanyType = null;
        var conTypeId = "ConTypeId";
        if (ASPxClientControl.GetControlCollection().GetByName("ConCompanyId") != null) {
            selectedCompanyId = ASPxClientControl.GetControlCollection().GetByName("ConCompanyId").GetSelectedIndex();
            if (selectedCompanyId !== -1) {
                selectedCompanyType = ASPxClientControl.GetControlCollection().GetByName("ConCompanyId").listBox.GetItem(selectedCompanyId).texts[2];
            } else {
                var ConTypeComboBox = ASPxClientControl.GetControlCollection().GetByName('ConTypeId');
                if (ConTypeComboBox !== null) {
                    ConTypeComboBox.SetValue(null);
                    ConTypeComboBox.ClearItems();
                }
            }
        }
        else if (ASPxClientControl.GetControlCollection().GetByName("ConCompanyId_popup") != null) {
            selectedCompanyId = ASPxClientControl.GetControlCollection().GetByName("ConCompanyId_popup").GetSelectedIndex();
            selectedCompanyType = ASPxClientControl.GetControlCollection().GetByName("ConCompanyId_popup").listBox.GetItem(selectedCompanyId).texts[2];
            conTypeId = "ConTypeId_popup";
        }
        if (selectedCompanyId !== null && selectedCompanyType !== null) {
            M4PLWindow.DataView.GetContactTypeAjaxCall(s, e, selectedCompanyType, conTypeId)
        }
    }

    var _getContactTypeAjaxCall = function (s, e, selectedCompanyType, conTypeId) {
        $.ajax({
            type: "GET",
            async: false,
            cache: false,
            url: "/Common/GetContactType?lookupName=" + selectedCompanyType,
            success: function (response) {
                if (response.status == true) {
                    M4PLWindow.DataView.SetContactTypeDropDown(s, e, selectedCompanyType, conTypeId, response);
                }
            },
            error: function (err) {
                console.log("error", err);
            }
        });
    }

    var _setContactTypeDropDown = function (s, e, selectedCompanyType, conTypeId, result) {
        if (result !== null && result !== undefined) {
            var ConTypeComboBox = ASPxClientControl.GetControlCollection().GetByName(conTypeId);
            if (ConTypeComboBox !== null) {
                ConTypeComboBox.SetValue(null);
                ConTypeComboBox.ClearItems();

                var lookUps = result.lookupId;
                if (lookUps !== null)
                    for (var i = 0; i < lookUps.length; i++) {
                        ConTypeComboBox.AddItem(lookUps[i].Value, lookUps[i].Key);
                        if (selectedCompanyType == "Organization" && lookUps[i].Value == "Employee") {
                            ConTypeComboBox.SetSelectedItem(ConTypeComboBox.GetItem(i))
                        }
                        else if (selectedCompanyType == lookUps[i].Value) {
                            ConTypeComboBox.SetSelectedItem(ConTypeComboBox.GetItem(i))
                        }
                    }
            }
        }
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


    var _onPrgGatewayBatchEditStartEditing = function (s, e, isReadOnly) {
        isReadOnly = (isReadOnly === undefined) ? false : (isReadOnly == 'True') ? true : false;
        var templateColumn = s.GetColumnByField("PgdShipApptmtReasonCode");
        if (templateColumn && e.rowValues.hasOwnProperty(templateColumn.index)) {
            var cellInfo = e.rowValues[templateColumn.index];
            PgdShipApptmtReasonCodeEdit.SetValue(cellInfo.value);
            PgdShipApptmtReasonCodeEdit.SetFocus();
        }

        var templateColumn1 = s.GetColumnByField("PgdShipStatusReasonCode");
        if (templateColumn1 && e.rowValues.hasOwnProperty(templateColumn1.index)) {
            var cellInfo1 = e.rowValues[templateColumn1.index];
            PgdShipStatusReasonCodeEdit.SetValue(cellInfo1.value);
            PgdShipStatusReasonCodeEdit.SetFocus();
        }

        e.cancel = (!isReadOnly) ? !_allowBatchEdit[s.name] : isReadOnly;
    }

    var _onPrgGatewayBatchEditEndEditing = function (s, e) {

        var key = s.GetRowKey(e.visibleIndex)
        var templateColumn = s.GetColumnByField("PgdShipApptmtReasonCode");
        if (templateColumn && e.rowValues.hasOwnProperty(templateColumn.index)) {
            var cellInfo = e.rowValues[templateColumn.index];
            cellInfo.value = PgdShipApptmtReasonCodeEdit.GetValue();
            cellInfo.text = PgdShipApptmtReasonCodeEdit.GetValue();
        }
        var templateColumn1 = s.GetColumnByField("PgdShipStatusReasonCode");
        if (templateColumn1 && e.rowValues.hasOwnProperty(templateColumn1.index)) {
            var cellInfo1 = e.rowValues[templateColumn1.index];
            cellInfo1.value = PgdShipStatusReasonCodeEdit.GetValue();
            cellInfo1.text = PgdShipStatusReasonCodeEdit.GetValue();
        }

        window.setTimeout(function () { _setCustomButtonsVisibility(s, e); }, 0);
    }


    var _onJobGatewayBatchEditStartEditing = function (s, e, isReadOnly) {
        isReadOnly = (isReadOnly === undefined) ? false : (isReadOnly == 'True') ? true : false;
        var templateColumn = s.GetColumnByField("GwyShipApptmtReasonCode");
        if (templateColumn && e.rowValues.hasOwnProperty(templateColumn.index)) {
            var cellInfo = e.rowValues[templateColumn.index];
            GwyShipApptmtReasonCodeEdit.SetValue(cellInfo.value);
            GwyShipApptmtReasonCodeEdit.SetFocus();
        }

        var templateColumn1 = s.GetColumnByField("GwyShipStatusReasonCode");
        if (templateColumn1 && e.rowValues.hasOwnProperty(templateColumn1.index)) {
            var cellInfo1 = e.rowValues[templateColumn1.index];
            GwyShipStatusReasonCodeEdit.SetValue(cellInfo1.value);
            GwyShipStatusReasonCodeEdit.SetFocus();
        }


        e.cancel = (!isReadOnly) ? !_allowBatchEdit[s.name] : isReadOnly;
    }

    var _onJobGatewayBatchEditEndEditing = function (s, e) {

        var key = s.GetRowKey(e.visibleIndex)
        var templateColumn = s.GetColumnByField("GwyShipApptmtReasonCode");
        if (templateColumn && e.rowValues.hasOwnProperty(templateColumn.index)) {
            var cellInfo = e.rowValues[templateColumn.index];
            cellInfo.value = GwyShipApptmtReasonCodeEdit.GetValue();
            cellInfo.text = GwyShipApptmtReasonCodeEdit.GetValue();
        }

        var templateColumn1 = s.GetColumnByField("GwyShipStatusReasonCode");
        if (templateColumn1 && e.rowValues.hasOwnProperty(templateColumn1.index)) {
            var cellInfo1 = e.rowValues[templateColumn1.index];
            cellInfo1.value = GwyShipStatusReasonCodeEdit.GetValue();
            cellInfo1.text = GwyShipStatusReasonCodeEdit.GetValue();
        }

        //var tempColumnPCD = s.GetColumnByField("GwyGatewayPCD");
        //var tempColumnDateReference = s.GetColumnByField("GwyDateRefTypeId");
        //var ddp = ASPxClientControl.GetControlCollection().GetByName("JobDeliveryDateTimePlanned")
        //if (e.rowValues[tempColumnDateReference.index].text == "Pickup Date") {

        //}
        //else if (e.rowValues[tempColumnDateReference.index].text == "Delivery Date") {

        //}


        window.setTimeout(function () { _setCustomButtonsVisibility(s, e); }, 0);
    }

    var _onUpdateEditWithConfirmation = function (grid, e, route) {

        if (grid.batchEditApi.GetDeletedRowIndices().length > 0) {
            var allIds = [];
            for (var i = 0; i < grid.batchEditApi.GetDeletedRowIndices().length; i++)
                allIds.push(grid.GetRowKey(grid.batchEditApi.GetDeletedRowIndices()[i]));
            var url = JSON.stringify(route);
            $.ajax({
                type: "POST",
                url: "Common/GetDeleteConfimationMessage?strRoute=" + url + "&allRecordIds=" + String(allIds) + "&gridName=" + grid.name,
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

    var _onDBValidationBatchEditStartEditing = function (s, e, isReadOnly) {
        isReadOnly = (isReadOnly === undefined) ? false : (isReadOnly == 'True') ? true : false;
        var templateColumn = s.GetColumnByField("ValTableName");
        if (!e.rowValues.hasOwnProperty(templateColumn.index))
            return;
        var cellInfo = e.rowValues[templateColumn.index];
        ValTableNameEdit.SetValue(cellInfo.value);
        ValTableNameEdit.SetFocus();

        var templateColumn = s.GetColumnByField("ValFieldName");
        if (!e.rowValues.hasOwnProperty(templateColumn.index))
            return;
        var cellInfo = e.rowValues[templateColumn.index];
        ValFieldNameEdit.SetValue(cellInfo.value);
        ValFieldNameEdit.SetFocus();

        e.cancel = (!isReadOnly) ? !_allowBatchEdit[s.name] : isReadOnly;
    }

    var _onDBValidationBatchEditEndEditing = function (s, e) {

        var key = s.GetRowKey(e.visibleIndex)
        var templateColumn = s.GetColumnByField("ValTableName");
        if (!e.rowValues.hasOwnProperty(templateColumn.index))
            return;
        var cellInfo = e.rowValues[templateColumn.index];
        cellInfo.value = ValTableNameEdit.GetValue();
        cellInfo.text = ValTableNameEdit.GetValue();

        var templateColumn = s.GetColumnByField("ValFieldName");
        if (!e.rowValues.hasOwnProperty(templateColumn.index))
            return;
        var cellInfo = e.rowValues[templateColumn.index];
        cellInfo.value = ValFieldNameEdit.GetValue();
        cellInfo.text = ValFieldNameEdit.GetValue();

        window.setTimeout(function () { _setCustomButtonsVisibility(s, e); }, 0);
    }

    var _contextMenu = function (s, e, currentGrid, isGroupingApplied, isFromGatewayAction, isScheduledUrl, parentId, gatewayActionFormName) {
        ASPxClientUtils.AttachEventToElement(document, "scroll", function (evt) {
            if (e.menu !== undefined && e.menu !== "undefined")
                e.menu.SetVisible(false);
        });

        if (isGroupingApplied == "True") {
            for (var i = 0; e.menu.GetItem(i) != null; i++) {
                var currentName = JSON.parse(e.menu.GetItem(i).name);
                if ((currentName.Action == "FormView") && (currentName.RecordId >= 0)) {
                    e.menu.GetItem(i).SetEnabled(currentGrid.GetRowKey(e.index) != null);
                }
            }
        }
        if (isFromGatewayAction) {
            if (e.index > -1) {
                //$.ajax({
                //    type: "GET",
                //    url: isScheduledUrl + "?id=" + currentGrid.GetRowKey(e.index) + "&parentId=" + parentId,
                //    async: false,
                //    success: function (response) {
                //        if (response) {
                //            for (var i = 0; e.menu.GetItem(i) != null; i++) {
                //                var currentName = JSON.parse(e.menu.GetItem(i).name);
                //                if (currentName) {
                //                    if (currentName.Action == gatewayActionFormName) {
                //                        if (response.isScheduled && (currentName.Filters.FieldName == response.actionSchedule)) {
                //                            e.menu.GetItem(i).SetEnabled(false);
                //                        } else if (!response.isScheduled && (currentName.Filters.FieldName != response.actionSchedule)) {
                //                            e.menu.GetItem(i).SetEnabled(false);
                //                        } else
                //                            e.menu.GetItem(i).SetEnabled(true);
                //                    }
                //                }
                //                for (var j = 0; j < e.menu.GetItem(i).items.length; j++) {
                //                    var childRoute = JSON.parse(e.menu.GetItem(i).items[j].name);
                //                    if (childRoute) {
                //                        if (childRoute.Action == gatewayActionFormName) {
                //                            if (response.isScheduled && (childRoute.Filters.FieldName == response.actionSchedule)) {
                //                                e.menu.GetItem(i).items[j].SetEnabled(false);
                //                            } else if (!response.isScheduled && (childRoute.Filters.FieldName != response.actionSchedule)) {
                //                                e.menu.GetItem(i).items[j].SetEnabled(false);
                //                            } else
                //                                e.menu.GetItem(i).items[j].SetEnabled(true);
                //                        }
                //                    }
                //                    for (var k = 0; k < e.menu.GetItem(i).items[j].items.length; k++) {
                //                        var subChildRoute = JSON.parse(e.menu.GetItem(i).items[j].items[k].name);
                //                        if (subChildRoute) {
                //                            if (subChildRoute.Action == gatewayActionFormName) {
                //                                if (response.isScheduled && (subChildRoute.Filters.FieldName == response.actionSchedule)) {
                //                                    e.menu.GetItem(i).items[j].items[k].SetEnabled(false);
                //                                } else if (!response.isScheduled && (subChildRoute.Filters.FieldName != response.actionSchedule)) {
                //                                    e.menu.GetItem(i).items[j].items[k].SetEnabled(false);
                //                                } else
                //                                    e.menu.GetItem(i).items[j].items[k].SetEnabled(true);
                //                            }
                //                        }
                //                    }
                //                }
                //            }
                //        }
                //    }
                //});

                for (var i = 0; e.menu.GetItem(i) != null; i++) {
                    var currentName = JSON.parse(e.menu.GetItem(i).name);
                    if (currentName) {
                        if (currentName.Action == gatewayActionFormName) {
                            e.menu.GetItem(i).SetEnabled(true);
                        }
                    }
                    for (var j = 0; j < e.menu.GetItem(i).items.length; j++) {
                        var currentName = JSON.parse(e.menu.GetItem(i).items[j].name);
                        if (currentName) {
                            if (currentName.Action == gatewayActionFormName) {
                                e.menu.GetItem(i).items[j].SetEnabled(true);
                            }
                        }
                        for (var k = 0; k < e.menu.GetItem(i).items[j].items.length; k++) {
                            var subChildRoute = JSON.parse(e.menu.GetItem(i).items[j].items[k].name);
                            if (subChildRoute) {
                                if (subChildRoute.Action == gatewayActionFormName) {
                                    e.menu.GetItem(i).items[j].items[k].SetEnabled(true);
                                }
                            }
                        }
                    }
                }

            } else {
                for (var i = 0; e.menu.GetItem(i) != null; i++) {
                    var currentName = JSON.parse(e.menu.GetItem(i).name);
                    if (currentName) {
                        if (currentName.Action == gatewayActionFormName) {
                            e.menu.GetItem(i).SetEnabled(false);
                        }
                    }
                    for (var j = 0; j < e.menu.GetItem(i).items.length; j++) {
                        var currentName = JSON.parse(e.menu.GetItem(i).items[j].name);
                        if (currentName) {
                            if (currentName.Action == gatewayActionFormName) {
                                e.menu.GetItem(i).items[j].SetEnabled(false);
                            }
                        }
                        for (var k = 0; k < e.menu.GetItem(i).items[j].items.length; k++) {
                            var subChildRoute = JSON.parse(e.menu.GetItem(i).items[j].items[k].name);
                            if (subChildRoute) {
                                if (subChildRoute.Action == gatewayActionFormName) {
                                    //e.menu.GetItem(i).items[j].items[k].SetEnabled(false);
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    return {
        OnInit: _onInit,
        OnContextMenu: _onContextMenu,
        OnBeginCallback: _onBeginCallback,
        OnBatchEditStartEditing: _onBatchEditStartEditing,
        OnActRoleBatchEditStartEditing: _onActRoleBatchEditStartEditing,
        OnBatchEditEndEditing: _onBatchEditEndEditing,
        OnCustomButtonClick: _onCustomButtonClick,
        OnHavingChildCustomButtonClick: _onHavingChildCustomButtonClick,
        OnComboBoxValueChanged: _onComboBoxValueChanged,
        OnCompanyComboBoxValueChanged: _onCompanyComboBoxValueChanged,
        GetContactTypeAjaxCall: _getContactTypeAjaxCall,
        SetContactTypeDropDown: _setContactTypeDropDown,
        OnUpdateEdit: _onUpdateEdit,
        OnUpdateEditWithDelete: _onUpdateEditWithDelete,
        OnCancelEdit: _onCancelEdit,
        OnEndCallback: _onEndCallback,
        OnDetailRowExpanding: _onDetailRowExpanding,
        OnDetailRowCollapsing: _onDetailRowCollapsing,
        OnColumnResized: _onColumnResized,
        ContextMenu: _contextMenu,
        MenuDriverBatchEditStartEditing: _onMenuDriverBatchEditStartEditing,
        MenuBatchEditEndEditing: _onMenuBatchEditEndEditing,
        SetCutomeButtonsVisibility: _setCustomButtonsVisibility,

        PrgGatewayBatchEditStartEditing: _onPrgGatewayBatchEditStartEditing,
        PrgGatewayBatchEditEndEditing: _onPrgGatewayBatchEditEndEditing,
        JobGatewayBatchEditStartEditing: _onJobGatewayBatchEditStartEditing,
        JobGatewayBatchEditEndEditing: _onJobGatewayBatchEditEndEditing,
        OnUpdateEditWithConfirmation: _onUpdateEditWithConfirmation,
        OnDBValidationBatchEditEndEditing: _onDBValidationBatchEditEndEditing,
        OnDBValidationBatchEditStartEditing: _onDBValidationBatchEditStartEditing
    };
}();

M4PLWindow.Theme = function () {
    var _onThemeChange = function () {
        alert("selected new theme");
    }
    return { OnThemeChange: _onThemeChange }
}();

M4PLWindow.FormView = function () {
    var params;
    var delCount;
    var delRecover;
    var init = function (p) {
        params = p;
        delCount = 1;
        delRecover = 1;
        $(document).on('click', 'a', function () {

            if ($(this).text() != undefined && $(this).text() == "Recover") {
                delRecover = ++delRecover;
                if (delCount == delRecover) {
                    var currentGridName = $(this).parents('table').parents('table').attr('id');
                    if (currentGridName != undefined) {
                        M4PLWindow.SubDataViewsHaveChanges[currentGridName] = false;
                        M4PLWindow.PopupDataViewHasChanges[currentGridName] = false;
                        M4PLWindow.DataViewsHaveChanges[currentGridName] = false;
                        $("#" + "btnSave" + currentGridName).addClass("noHover");
                        $("#" + "btnCancel" + currentGridName).addClass("noHover");
                    }
                }
            }
            else if ($(this).text() != undefined && $(this).text() == "Delete") {
                delCount = ++delCount;
            }
        });


    };

    var _clearErrorMessages = function () {
        $('.errorMessages, .recordPopupErrorMessages, .recordSubPopupErrorMessages').html('');
    }

    var _onCancel = function (s, form, strRoute) {
        if (!M4PLCommon.CheckHasChanges.CheckDataChanges()) {
            _clearErrorMessages();
            var route = JSON.parse(strRoute);
            if (ASPxClientControl.GetControlCollection().GetByName(route.OwnerCbPanel) && !ASPxClientControl.GetControlCollection().GetByName(route.OwnerCbPanel).InCallback())
                ASPxClientControl.GetControlCollection().GetByName(route.OwnerCbPanel).PerformCallback({ strRoute: strRoute });
            DevExCtrl.Ribbon.DoCallBack(route);
        } else {
            M4PLCommon.CallerNameAndParameters = { "Caller": _onCancel, "Parameters": [s, form, strRoute] };
            M4PLCommon.CheckHasChanges.ShowConfirmation();
        }
    }

    var _onAddOrEdit = function (s, form, controlSuffix, strRoute) {

        //To save opened Tab GridData
        var isSaveRequired = false;
        for (var gridName in M4PLWindow.SubDataViewsHaveChanges) {
            if (M4PLWindow.SubDataViewsHaveChanges.hasOwnProperty(gridName) && M4PLWindow.SubDataViewsHaveChanges[gridName])
                isSaveRequired = true;
        }

        if (isSaveRequired && ASPxClientControl.GetControlCollection().GetByName('pageControl')) {
            $('#pageControl_C' + pageControl.activeTabIndex).find('div[id^="btnSave"][id$="GridView"]').trigger('click');
            M4PLWindow.IsFromConfirmSaveClick = true;
            M4PLCommon.IsFromSubDataViewSaveClick = true;
            M4PLCommon.CallerNameAndParameters = { "Caller": _onAddOrEdit, "Parameters": [s, form, controlSuffix, strRoute] };
            return;
        }
        DevExCtrl.LoadingPanel.Show(GlobalLoadingPanel);
        var putOrPostData = $(form).serializeArray();
        var securityGrid = null;
        if (typeof SecurityByRoleGridView !== "undefined" && ASPxClientUtils.IsExists(SecurityByRoleGridView) && ASPxClientUtils.IsExists(pnlOrgActSecurityRoundPanel)) {
            securityGrid = ASPxClientControl.GetControlCollection().GetByName('SecurityByRoleGridView');
            var totalRecords = securityGrid.GetVisibleRowsOnPage();
            var rows = securityGrid.batchEditHelper.GetEditState().insertedRowValues;
            for (var key in rows) {
                if (rows[key].StatusId !== "1")
                    totalRecords--;
            }
            if (totalRecords > 0) {
                rows = securityGrid.batchEditHelper.GetEditState().modifiedRowValues;
                for (var key in rows) {
                    if (rows[key].StatusId !== "1")
                        totalRecords--;
                }
            }

            putOrPostData.push({ name: "IsSecurityDefined", value: totalRecords > 0 });
        }
        var conditionsGrid = null;
        if (typeof PrgEdiConditionGridView !== "undefined" && ASPxClientUtils.IsExists(PrgEdiConditionGridView) && ASPxClientUtils.IsExists(PrgEdiConditionGridView)) {
            conditionsGrid = ASPxClientControl.GetControlCollection().GetByName('PrgEdiConditionGridView');
        }
        putOrPostData.push({ name: "UserDateTime", value: moment.now() });
        _clearErrorMessages();

        //To update FormViewHasChanges values
        M4PLCommon.Control.UpdateFormViewHasChangesWithDefaultValue();

        if (putOrPostData && putOrPostData.length > 0) {
            if (controlSuffix && (controlSuffix != "")) {
                for (var ctrlIdx = 0; ctrlIdx < putOrPostData.length; ctrlIdx++) {
                    putOrPostData[ctrlIdx].name = putOrPostData[ctrlIdx].name.replace(controlSuffix, "");
                    //Below "DXMVCEditorsValues" checking because all the Editor's value with _popup name will be available with this key and in post these values only will go
                    if (putOrPostData[ctrlIdx].name == "DXMVCEditorsValues")
                        putOrPostData[ctrlIdx].value = putOrPostData[ctrlIdx].value.replace(new RegExp(controlSuffix, 'g'), "");
                }
            }


            $.ajax({
                type: "POST",
                url: $(form).attr("action"),
                data: putOrPostData,
                success: function (response) {
                    var isFromConfirmSave = M4PLWindow.IsFromConfirmSaveClick;
                    M4PLWindow.IsFromConfirmSaveClick = false;
                    if (response && response.status && response.status === true) {
                        if (securityGrid !== null && securityGrid.GetVisibleRowsOnPage() > 0) {
                            securityGrid.callbackCustomArgs["orgRefRoleId"] = response.route.RecordId;
                            securityGrid.UpdateEdit();
                        }
                        if (conditionsGrid !== null && conditionsGrid.GetVisibleRowsOnPage() > 0) {
                            conditionsGrid.callbackCustomArgs["prgEdiHeaderId"] = response.route.RecordId;
                            conditionsGrid.UpdateEdit();
                        }
                        if (response.redirectLogin !== undefined && response.redirectLogin) {
                            window.location.href = "/Account/Logout";
                            return;
                        }
                        M4PLCommon.CurrentByteArrayCount = 0;
                        if (response.byteArray && response.byteArray.length > 0 && response.route) {
                            M4PLCommon.RichEdit.RichEditorsPerformCallBack(response.route, response.byteArray);
                        }
                        var formInterval = setInterval(function () {

                            if ((M4PLCommon.CurrentByteArrayCount <= 0) && AppCbPanel && !AppCbPanel.InCallback()) {
                                window.clearInterval(formInterval);
                                var route = JSON.parse(strRoute);
                                if (route.Controller === "Program") {
                                    _refreshProgramPage(response.record, strRoute, response.selectedNode, response.refreshContent, response.isActiveRecord);
                                    if (response.displayMessage) {
                                        response.displayMessage.HeaderIcon = null;
                                        response.displayMessage.MessageTypeIcon = null;
                                        DisplayMessageControl.PerformCallback({ strDisplayMessage: JSON.stringify(response.displayMessage) });
                                    }
                                }
                                else if (response.reloadApplication && response.reloadApplication === true) {
                                    M4PLCommon.Common.ReloadApplication();
                                    return;
                                }
                                else if (route.Controller === "PrgEdiHeader") {

                                    if (ASPxClientControl.GetControlCollection().GetByName(route.OwnerCbPanel) && !ASPxClientControl.GetControlCollection().GetByName(route.OwnerCbPanel).InCallback()) {
                                        if (response.refreshContent) {
                                            ASPxClientControl.GetControlCollection().GetByName(route.OwnerCbPanel).PerformCallback({ strRoute: JSON.stringify(route) });
                                        }
                                        if (response.displayMessage)
                                            DisplayMessageControl.PerformCallback({ strDisplayMessage: JSON.stringify(response.displayMessage) });
                                    }
                                }
                                else {
                                    if (route.RecordId == 0 && response.route && response.route.RecordId > 0) {
                                        route.RecordId = response.route.RecordId;
                                        route.PreviousRecordId = response.route.PreviousRecordId;
                                    }

                                    if (ASPxClientControl.GetControlCollection().GetByName("pageControl"))
                                        route.TabIndex = ASPxClientControl.GetControlCollection().GetByName("pageControl").activeTabIndex;

                                    if (response.route && response.route.RecordId > 0 && response.route.Url === "UserHeaderCbPanel" && ASPxClientControl.GetControlCollection().GetByName(response.route.Url) && !ASPxClientControl.GetControlCollection().GetByName(response.route.Url).InCallback())////refresh header and using in ContentLayout
                                        ASPxClientControl.GetControlCollection().GetByName(response.route.Url).PerformCallback();
                                    if (!isFromConfirmSave)
                                        AppCbPanel.PerformCallback({ strRoute: JSON.stringify(route) });
                                    if (response.displayMessage)
                                        DisplayMessageControl.PerformCallback({ strDisplayMessage: JSON.stringify(response.displayMessage) });

                                }
                                DevExCtrl.LoadingPanel.Hide(GlobalLoadingPanel);
                                if (!isFromConfirmSave)
                                    DevExCtrl.Ribbon.DoCallBack(route);
                                else
                                    M4PLCommon.CheckHasChanges.RedirectToClickedItem();
                            }
                        }, 500);

                    }
                    else if (response.errMessages && response.errMessages.length > 0) {
                        for (var i = 0; i < response.errMessages.length; i++)
                            $('.errorMessages').append('<p>* ' + response.errMessages[i] + '</p>');
                        DevExCtrl.LoadingPanel.Hide(GlobalLoadingPanel);
                    }
                    else if (response.displayMessage) {
                        DisplayMessageControl.PerformCallback({ strDisplayMessage: JSON.stringify(response.displayMessage) });
                        DevExCtrl.LoadingPanel.Hide(GlobalLoadingPanel);
                    }
                }
            });
        }
    }

    /*->parameter parentRoute is used to where to redirectAction*/
    var _onPopupAddOrEdit = function (form, controlSuffix, currentRoute, isNewContactCard, strDropDownViewModel) {

        if (ASPxClientControl.GetControlCollection().GetByName('btnSaveAttachmentGridView') && ASPxClientControl.GetControlCollection().GetByName('btnSaveAttachmentGridView').IsVisible()) {
            var btn = ASPxClientControl.GetControlCollection().GetByName('btnSaveAttachmentGridView');
            btn.DoClick();
        }

        DevExCtrl.LoadingPanel.Show(GlobalLoadingPanel);
        _clearErrorMessages();

        //To update FormViewHasChanges values
        M4PLCommon.Control.UpdateFormViewHasChangesWithDefaultValue();

        var putOrPostData = $(form).serializeArray();
        if (currentRoute.PreviousRecordId != null && currentRoute.PreviousRecordId != 0
            && currentRoute.PreviousRecordId != undefined && currentRoute.Action == "ContactCardFormView" && currentRoute.EntityName === "Contact") {

            putOrPostData.push({ name: "JobId", value: currentRoute.PreviousRecordId });

        }
        if (currentRoute.Entity == "JobXcblInfo" && currentRoute.Action == "FormView") {
            putOrPostData.IsAccepted = currentRoute.IsPBSReport;
        }

        putOrPostData.push({ name: "UserDateTime", value: moment.now() });
        if (strDropDownViewModel != null && strDropDownViewModel.Entity == 2 && strDropDownViewModel.CompanyId > 0) {
            putOrPostData.push({ name: "ConCompanyId", value: strDropDownViewModel.CompanyId });
        }

        if (putOrPostData && putOrPostData.length > 0) {
            for (var ctrlIdx = 0; ctrlIdx < putOrPostData.length; ctrlIdx++) {
                putOrPostData[ctrlIdx].name = putOrPostData[ctrlIdx].name.replace(controlSuffix, "").replace("_popup", "");
                //Below "DXMVCEditorsValues" checking because all the Editor's value with _popup name will be available with this key and in post these values only will go
                if (putOrPostData[ctrlIdx].name == "DXMVCEditorsValues") {
                    putOrPostData[ctrlIdx].value = putOrPostData[ctrlIdx].value.replace(new RegExp(controlSuffix, 'g'), "").replace(new RegExp("_popup", 'g'), "");
                }
            }
            $.ajax({
                type: "POST",
                url: $(form).attr("action"),
                data: putOrPostData,
                success: function (response) {
                    if (response && response.status && response.status === true) {
                        var ownerCbPanel = ASPxClientControl.GetControlCollection().GetByName(currentRoute.OwnerCbPanel);
                        if (currentRoute.OwnerCbPanel === "pnlJobDetail" && currentRoute.Action === "ContactCardFormView") {
                            if (ASPxClientControl.GetControlCollection().GetByName("CallbackPanelAnalystResponsibleDriver")) {
                                var driverpanel = ASPxClientControl.GetControlCollection().GetByName("CallbackPanelAnalystResponsibleDriver");
                                driverpanel.PerformCallback({ 'selectedId': response.route.RecordId });
                            }
                        }
                        if (ownerCbPanel && !ownerCbPanel.InCallback()) {

                            response.route.OwnerCbPanel = currentRoute.OwnerCbPanel;
                            response.route.IsPopup = currentRoute.IsPopup;
                            if (!response.route.ParentEntity) {
                                response.route.ParentEntity = currentRoute.ParentEntity;
                                response.route.ParentRecordId = currentRoute.ParentRecordId;
                            }

                            M4PLCommon.CurrentByteArrayCount = 0;
                            if (response.byteArray && response.byteArray.length > 0 && response.route)
                                M4PLCommon.RichEdit.RichEditorsPerformCallBack(response.route, response.byteArray);
                            var currentPopupInterval = setInterval(function () {
                                if ((M4PLCommon.CurrentByteArrayCount <= 0)) {
                                    window.clearInterval(currentPopupInterval);

                                    if (!response.doNotReload) {
                                        if (response.route.Controller === "JobGateway" || response.route.Controller === "JobDocReference") {
                                            var resultRoute = response.tabRoute;
                                            if (resultRoute != null) {
                                                resultRoute.Controller = "Job";
                                                JobDataViewCbPanel.PerformCallback({ strRoute: JSON.stringify(resultRoute) });
                                            }
                                            ownerCbPanel.PerformCallback({ selectedId: response.route.RecordId });
                                        } else {
                                            ownerCbPanel.PerformCallback({ strRoute: JSON.stringify(response.route), selectedId: response.route.RecordId, strDropDownViewModel: (!strDropDownViewModel) ? null : JSON.stringify(strDropDownViewModel) });
                                        }
                                    }

                                    if (response.displayMessage)
                                        DisplayMessageControl.PerformCallback({ strDisplayMessage: JSON.stringify(response.displayMessage) });
                                    if (isNewContactCard && (isNewContactCard === 'True')) {
                                        M4PLCommon.ContactCombobox.OnNewClick(currentRoute, (!strDropDownViewModel) ? null : JSON.stringify(strDropDownViewModel));
                                    } else {
                                        DevExCtrl.PopupControl.Close();
                                    }
                                    DevExCtrl.LoadingPanel.Hide(GlobalLoadingPanel);
                                }
                            }, 500);

                            //if (response.route.Controller === "JobGateway" && response.tabRoute != null && response.tabRoute != undefined) {
                            //    //ASPxClientControl.GetControlCollection().GetByName("pageControl").PerformCallback({ strRoute: response.tabRoute });
                            //    var resultRoute = response.tabRoute;
                            //    resultRoute.OwnerCbPanel = "JobDataViewCbPanel";
                            //    resultRoute.Controller = "Job";
                            //    resultRoute.Action = "FormView";
                            //    ASPxClientControl.GetControlCollection().GetByName(resultRoute.OwnerCbPanel).PerformCallback({ strRoute: resultRoute });                                
                            //}


                            //if (response.jobDeliveryPlanedDate != null && response.jobDeliveryPlanedDate != '') {
                            //    if (response.route.Controller === "JobGateway") {
                            //        var deliveryDatectrl = ASPxClientControl.GetControlCollection().GetByName('JobDeliveryDateTimePlanned');
                            //        if (deliveryDatectrl != null) {
                            //            deliveryDatectrl.SetValue(new Date(response.jobDeliveryPlanedDate));
                            //        }
                            //    }
                            //}

                            //if (response.jobGatewayStatus != null && response.jobGatewayStatus != '') {
                            //    if (response.route.Controller === "JobGateway") {
                            //        var gatewayStatusctrl = ASPxClientControl.GetControlCollection().GetByName('JobGatewayStatus');
                            //        if (gatewayStatusctrl != null) {
                            //            gatewayStatusctrl.SetValue(response.jobGatewayStatus);
                            //        }
                            //    }
                            //}
                            //if (response.route.Controller === "JobGateway" && response.gatewayTypeIdName != null && response.gatewayTypeIdName != ''
                            //    && response.gatewayTypeIdName != undefined && response.gatewayTypeIdName.toLowerCase() === "action") {
                            //    var JobPreferredMethod = ASPxClientControl.GetControlCollection().GetByName('JobPreferredMethod');
                            //    var JobDeliverySitePOCEmail2ctrl = ASPxClientControl.GetControlCollection().GetByName('JobDeliverySitePOCEmail2');
                            //    var JobDeliverySitePOCPhone2ctrl = ASPxClientControl.GetControlCollection().GetByName('JobDeliverySitePOCPhone2');
                            //    var jobDeliverySitePOC2ctrl = ASPxClientControl.GetControlCollection().GetByName('JobDeliverySitePOC2');

                            //    if (JobPreferredMethod != null && JobPreferredMethod != undefined) {
                            //        JobPreferredMethod.SetValue(response.preferredMethod);
                            //    }

                            //    if (JobDeliverySitePOCEmail2ctrl != null && JobDeliverySitePOCEmail2ctrl != undefined) {
                            //        JobDeliverySitePOCEmail2ctrl.SetValue(response.gwyPersonEmail);
                            //    }

                            //    if (JobDeliverySitePOCPhone2ctrl != null && JobDeliverySitePOCPhone2ctrl != undefined) {
                            //        JobDeliverySitePOCPhone2ctrl.SetValue(response.gwyPersonPhone);
                            //    }

                            //    if (jobDeliverySitePOC2ctrl != null && jobDeliverySitePOC2ctrl != undefined) {
                            //        jobDeliverySitePOC2ctrl.SetValue(response.gwyPerson);
                            //    }
                            //}

                            //if (response.jobDeliveryWindowStartDate != null && response.jobDeliveryWindowEndDate != null) {
                            //    if (response.route.Controller === "JobGateway") {
                            //        var deliveryWindowStartDatectrl = ASPxClientControl.GetControlCollection().GetByName('WindowDelStartTime');
                            //        var deliveryWindowEndDatectrl = ASPxClientControl.GetControlCollection().GetByName('WindowDelEndTime');
                            //        if (response.jobDeliveryWindowStartDate != '' && response.jobDeliveryWindowEndDate != ''
                            //            && response.jobDeliveryWindowStartDate != null && response.jobDeliveryWindowEndDate != null
                            //            && response.jobDeliveryWindowStartDate != undefined && response.jobDeliveryWindowEndDate != undefined) {
                            //            if (deliveryWindowStartDatectrl != null) {
                            //                //response.jobDeliveryWindowStartDate = new Date(parseInt(response.jobDeliveryWindowStartDate.replace("/Date(", "").replace(")/", ""), 10));
                            //                deliveryWindowStartDatectrl.SetValue(new Date(response.jobDeliveryWindowStartDate));
                            //            }
                            //            if (deliveryWindowEndDatectrl != null) {
                            //                //response.jobDeliveryWindowEndDate = new Date(parseInt(response.jobDeliveryWindowEndDate.replace("/Date(", "").replace(")/", ""), 10));
                            //                deliveryWindowEndDatectrl.SetValue(new Date(response.jobDeliveryWindowEndDate));
                            //            }
                            //        }
                            //    }
                            //}

                            //if (response.statusId != null && response.completed != null) {
                            //    if (response.route.Controller === "JobGateway") {
                            //        var jobStatusId = ASPxClientControl.GetControlCollection().GetByName('StatusId');
                            //        var jobCompleted = ASPxClientControl.GetControlCollection().GetByName('JobCompleted');
                            //        if (jobStatusId != null) {
                            //            jobStatusId.SetValue(response.statusId);
                            //        }
                            //        if (jobCompleted != null) {
                            //            jobCompleted.SetValue(response.completed);
                            //        }
                            //    }
                            //}
                        }
                    }
                    else if (response.status === false && response.errMessages && (response.errMessages.length > 0)) {
                        DevExCtrl.LoadingPanel.Hide(GlobalLoadingPanel);
                        DevExCtrl.PopupControl.AppendErrorMessages(response.errMessages);
                    }

                    if (response.displayMessage != undefined) {
                        if (response.displayMessage.Code == "NavCustomer") {
                            M4PLCommon.NavSync.NavBarIndexSelect("Customer", "Data View Screen")
                        }
                        else if (response.displayMessage.Code == "NavVendor") {
                            M4PLCommon.NavSync.NavBarIndexSelect("Vendor", "Data View Screen")
                        }
                    }
                },
                error: function (xhr) {
                    DevExCtrl.LoadingPanel.Hide(GlobalLoadingPanel);
                }
            });
        }
    }

    var _onPopupCancel = function (form, controlSuffix, currentRoute, isNewContactCard, strDropDownViewModel) {

        var selectedTxtBox = ASPxClientControl.GetControlCollection().GetByName('ERPId');
        if (selectedTxtBox == null)
            selectedTxtBox = ASPxClientControl.GetControlCollection().GetByName('ERPId_popup');
        if (selectedTxtBox != null)
            selectedTxtBox.SetValue("");
        M4PLWindow.FormView.OnPopupAddOrEdit(form, controlSuffix, currentRoute, isNewContactCard, strDropDownViewModel);
    }
    var _onPopupUpdateJobGatewayComplete = function (form, controlSuffix, currentRoute, isNewContactCard) {

        DevExCtrl.LoadingPanel.Show(GlobalLoadingPanel);
        _clearErrorMessages();

        var putOrPostData = $(form).serializeArray();
        putOrPostData.push({ name: "UserDateTime", value: moment.now() });

        //To update FormViewHasChanges values
        M4PLCommon.Control.UpdateFormViewHasChangesWithDefaultValue();

        if (putOrPostData && putOrPostData.length > 0) {
            for (var ctrlIdx = 0; ctrlIdx < putOrPostData.length; ctrlIdx++) {
                putOrPostData[ctrlIdx].name = putOrPostData[ctrlIdx].name.replace(controlSuffix, "").replace("_popup", "");
                //Below "DXMVCEditorsValues" checking because all the Editor's value with _popup name will be available with this key and in post these values only will go
                if (putOrPostData[ctrlIdx].name == "DXMVCEditorsValues") {
                    putOrPostData[ctrlIdx].value = putOrPostData[ctrlIdx].value.replace(new RegExp(controlSuffix, 'g'), "").replace(new RegExp("_popup", 'g'), "");

                }

            }
            $.ajax({
                type: "POST",
                url: $(form).attr("action"),
                data: putOrPostData,
                success: function (response) {

                    if (response && response.status && response.status === true) {

                        if (typeof (RecordSubPopupControl) !== "undefined" && RecordSubPopupControl.IsVisible())
                            RecordSubPopupControl.Hide();
                        else
                            RecordPopupControl.Hide();

                        DevExCtrl.LoadingPanel.Hide(GlobalLoadingPanel);
                        if (ASPxClientControl.GetControlCollection().GetByName(currentRoute.OwnerCbPanel)) {
                            var grid = ASPxClientControl.GetControlCollection().GetByName(currentRoute.OwnerCbPanel);
                            var rowIndex = grid.GetFocusedRowIndex();
                            if (grid.batchEditApi.GetColumnIndex("GwyCompleted") !== null)
                                grid.batchEditApi.SetCellValue(rowIndex, 'GwyCompleted', true);

                            if (grid.batchEditApi.GetColumnIndex("GwyGatewayCode") !== null)
                                grid.batchEditApi.SetCellValue(rowIndex, 'GwyGatewayCode', response.record.GwyGatewayCode);
                            if (grid.batchEditApi.GetColumnIndex("GwyGatewayTitle") !== null)
                                grid.batchEditApi.SetCellValue(rowIndex, 'GwyGatewayTitle', response.record.GwyGatewayTitle);
                            if (grid.batchEditApi.GetColumnIndex("GwyShipStatusReasonCode") !== null)
                                grid.batchEditApi.SetCellValue(rowIndex, 'GwyShipStatusReasonCode', response.record.GwyShipStatusReasonCode);
                            if (grid.batchEditApi.GetColumnIndex("GwyShipApptmtReasonCode") !== null)
                                grid.batchEditApi.SetCellValue(rowIndex, 'GwyShipApptmtReasonCode', response.record.GwyShipApptmtReasonCode);
                        }
                        else if (currentRoute.OwnerCbPanel === "formView") {
                            if (ASPxClientControl.GetControlCollection().GetByName("GwyCompleted" + "_popup") !== null)
                                ASPxClientControl.GetControlCollection().GetByName("GwyCompleted" + "_popup").SetChecked(true);

                            if (ASPxClientControl.GetControlCollection().GetByName("GwyGatewayCode" + "_popup") !== null)
                                ASPxClientControl.GetControlCollection().GetByName("GwyGatewayCode" + "_popup").SetValue(response.record.GwyGatewayCode);
                            if (ASPxClientControl.GetControlCollection().GetByName("GwyGatewayTitle" + "_popup") !== null)
                                ASPxClientControl.GetControlCollection().GetByName("GwyGatewayTitle" + "_popup").SetValue(response.record.GwyGatewayTitle);
                            if (ASPxClientControl.GetControlCollection().GetByName("GwyShipStatusReasonCode" + "_popup") !== null)
                                ASPxClientControl.GetControlCollection().GetByName("GwyShipStatusReasonCode" + "_popup").SetValue(response.record.GwyShipStatusReasonCode);
                            if (ASPxClientControl.GetControlCollection().GetByName("GwyShipApptmtReasonCode" + "_popup") !== null)
                                ASPxClientControl.GetControlCollection().GetByName("GwyShipApptmtReasonCode" + "_popup").SetValue(response.record.GwyShipApptmtReasonCode);
                        }
                    }

                    else if (response.status === false && response.errMessages && (response.errMessages.length > 0)) {
                        DevExCtrl.LoadingPanel.Hide(GlobalLoadingPanel);
                        DevExCtrl.PopupControl.AppendErrorMessages(response.errMessages);
                    }
                },
                error: function (xhr) {
                    DevExCtrl.LoadingPanel.Hide(GlobalLoadingPanel);
                }
            });
        }
    }

    var _onAssignProgramVendorMap = function (programId, unAssignTreeControl) {
        var checkedNodes = [];
        for (var i = 0; i < unAssignTreeControl.GetNodeCount(); i++) {
            var vendorId = 0;
            var parentNode = unAssignTreeControl.GetNode(i);
            if (parentNode.GetChecked()) {
                vendorId = parseInt(parentNode.name.split('_')[1]);
                checkedNodes.push({ PvlVendorID: vendorId, Id: 0 });
            }
            else {
                for (var j = 0; j < unAssignTreeControl.GetNode(i).nodes.length; j++) {
                    var das = unAssignTreeControl.GetNode(i).nodes[j];
                    var locationNode = unAssignTreeControl.GetNode(i).nodes[j];

                    if (locationNode.GetChecked() == true) {
                        vendorId = parseInt(parentNode.name.split('_')[1]);
                        checkedNodes.push({ PvlVendorID: vendorId, Id: parseInt(locationNode.name.split('_')[1]) });
                    }
                }
            }
        }

        if (checkedNodes.length > 0) {
            $.ajax({
                url: "/Program/PrgVendLocation/AssignVendors?assign=true&parentId=" + programId,
                data: JSON.stringify(checkedNodes),
                async: true,
                type: "POST",
                contentType: "application/json",
                success: function (data) {

                    cplMapVendorTreeViewPanel.PerformCallback();

                }
            });
        }
    };
    var _onUnAssignProgramVendorMap = function (programId, assignTreeControl) {
        var checkedNodes = [];

        for (var i = 0; i < assignTreeControl.GetNodeCount(); i++) {
            var vendorId = 0;
            var parentNode = assignTreeControl.GetNode(i);
            if (parentNode.GetChecked()) {
                vendorId = parseInt(parentNode.name.split('_')[1]);
                checkedNodes.push({ PvlVendorID: vendorId, Id: 0 });
            }
            else {
                for (var j = 0; j < assignTreeControl.GetNode(i).nodes.length; j++) {
                    var locationNode = assignTreeControl.GetNode(i).nodes[j];
                    if (locationNode.GetChecked() == true) {
                        vendorId = parseInt(parentNode.name.split('_')[1]);
                        checkedNodes.push({ PvlVendorID: 0, Id: parseInt(locationNode.name.split('_')[1]) });
                    }
                }
            }
        }

        if (checkedNodes.length > 0) {
            $.ajax({
                url: "/Program/PrgVendLocation/AssignVendors?assign=false&parentId=" + programId,
                data: JSON.stringify(checkedNodes),
                async: true,
                type: "POST",
                contentType: "application/json",
                success: function (data) {
                    cplMapVendorTreeViewPanel.PerformCallback();
                }
            });
        }
    };
    var _refreshProgramPage = function (record, actionControllerArea, selectedNode, refreshContent, isActiveRecord) {
        var nodeNames = [];
        if (ProgramTree !== "undefined") {
            var node = ProgramTree.GetSelectedNode();

            /*Special case if user deleted or made program inactive*/
            if (!isActiveRecord)
                selectedNode = node.parent.name;

            if (node !== null) {
                nodeNames.push(node.name);
                if (node.parent !== null) {
                    nodeNames.push(node.parent.name);
                    if (node.parent.parent !== null) {
                        nodeNames.push(node.parent.parent.name);
                        if (node.parent.parent.parent !== null) {
                            nodeNames.push(node.parent.parent.parent.name);
                        }
                    }
                }

                cplTreeViewPanel.PerformCallback({ nodes: JSON.stringify(nodeNames), selectedNode: selectedNode });

                var customerCode = DevExCtrl.TreeView.FindCustomerCode(ProgramTree.GetSelectedNode());

                if (refreshContent) {
                    if (cplTreeView && !cplTreeView.InCallback()) {
                        var route = {}
                        route.RecordId = parseInt(record.Id);
                        route.OwnerCbPanel = customerCode;
                        route.ParentRecordId = parseInt(selectedNode.split("_")[0]);
                        if (ASPxClientControl.GetControlCollection().GetByName("pageControl"))
                            route.TabIndex = ASPxClientControl.GetControlCollection().GetByName("pageControl").activeTabIndex;
                        setTimeout(cplTreeView.PerformCallback({ strRoute: JSON.stringify(route) }), 5000);
                    }
                }

                setTimeout(function () {
                    DevExCtrl.TreeView.SetBreadCrumb((!isActiveRecord) ? node.parent : ProgramTree.GetSelectedNode());
                }, 10000);
            }
        }
    };


    var _onAssignProgramCostVendorMap = function (programId, unAssignTreeControl) {
        var checkedNodes = [];
        for (var i = 0; i < unAssignTreeControl.GetNodeCount(); i++) {
            var vendorId = 0;
            var parentNode = unAssignTreeControl.GetNode(i);
            if (parentNode.GetChecked()) {
                vendorId = parseInt(parentNode.name.split('_')[1]);
                checkedNodes.push({ PclVendorID: vendorId, Id: 0 });
            }
            else {
                for (var j = 0; j < unAssignTreeControl.GetNode(i).nodes.length; j++) {
                    var das = unAssignTreeControl.GetNode(i).nodes[j];
                    var locationNode = unAssignTreeControl.GetNode(i).nodes[j];

                    if (locationNode.GetChecked() == true) {
                        vendorId = parseInt(parentNode.name.split('_')[1]);
                        checkedNodes.push({ PclVendorID: vendorId, Id: parseInt(locationNode.name.split('_')[1]) });
                    }
                }
            }
        }

        if (checkedNodes.length > 0) {
            $.ajax({
                url: "/Program/PrgCostLocation/AssignCostVendorsMapping?assign=true&parentId=" + programId,
                data: JSON.stringify(checkedNodes),
                async: true,
                type: "POST",
                contentType: "application/json",
                success: function (data) {

                    cplMapVendorCostTreeViewPanel.PerformCallback();

                }
            });
        }
    };
    var _onUnAssignProgramCostVendorMap = function (programId, assignTreeControl) {
        var checkedNodes = [];

        for (var i = 0; i < assignTreeControl.GetNodeCount(); i++) {
            var vendorId = 0;
            var parentNode = assignTreeControl.GetNode(i);
            if (parentNode.GetChecked()) {
                vendorId = parseInt(parentNode.name.split('_')[1]);
                checkedNodes.push({ PclVendorID: vendorId, Id: 0 });
            }
            else {
                for (var j = 0; j < assignTreeControl.GetNode(i).nodes.length; j++) {
                    var locationNode = assignTreeControl.GetNode(i).nodes[j];
                    if (locationNode.GetChecked() == true) {
                        vendorId = parseInt(parentNode.name.split('_')[1]);
                        checkedNodes.push({ PclVendorID: 0, Id: parseInt(locationNode.name.split('_')[1]) });
                    }
                }
            }
        }

        if (checkedNodes.length > 0) {
            $.ajax({
                url: "/Program/PrgCostLocation/AssignCostVendorsMapping?assign=false&parentId=" + programId,
                data: JSON.stringify(checkedNodes),
                async: true,
                type: "POST",
                contentType: "application/json",
                success: function (data) {
                    cplMapVendorCostTreeViewPanel.PerformCallback();
                }
            });
        }
    };

    var _onAssignProgramPriceVendorMap = function (programId, unAssignTreeControl) {
        var checkedNodes = [];
        for (var i = 0; i < unAssignTreeControl.GetNodeCount(); i++) {
            var vendorId = 0;
            var parentNode = unAssignTreeControl.GetNode(i);
            if (parentNode.GetChecked()) {
                vendorId = parseInt(parentNode.name.split('_')[1]);
                checkedNodes.push({ PblVendorID: vendorId, Id: 0 });
            }
            else {
                for (var j = 0; j < unAssignTreeControl.GetNode(i).nodes.length; j++) {
                    var das = unAssignTreeControl.GetNode(i).nodes[j];
                    var locationNode = unAssignTreeControl.GetNode(i).nodes[j];

                    if (locationNode.GetChecked() == true) {
                        vendorId = parseInt(parentNode.name.split('_')[1]);
                        checkedNodes.push({ PblVendorID: vendorId, Id: parseInt(locationNode.name.split('_')[1]) });
                    }
                }
            }
        }

        if (checkedNodes.length > 0) {
            $.ajax({
                url: "/Program/PrgBillableLocation/AssignPriceVendorsMapping?assign=true&parentId=" + programId,
                data: JSON.stringify(checkedNodes),
                async: true,
                type: "POST",
                contentType: "application/json",
                success: function (data) {

                    cplMapVendorPriceTreeViewPanel.PerformCallback();

                }
            });
        }
    };
    var _onUnAssignProgramPriceVendorMap = function (programId, assignTreeControl) {
        var checkedNodes = [];

        for (var i = 0; i < assignTreeControl.GetNodeCount(); i++) {
            var vendorId = 0;
            var parentNode = assignTreeControl.GetNode(i);
            if (parentNode.GetChecked()) {
                vendorId = parseInt(parentNode.name.split('_')[1]);
                checkedNodes.push({ PblVendorID: vendorId, Id: 0 });
            }
            else {
                for (var j = 0; j < assignTreeControl.GetNode(i).nodes.length; j++) {
                    var locationNode = assignTreeControl.GetNode(i).nodes[j];
                    if (locationNode.GetChecked() == true) {
                        vendorId = parseInt(parentNode.name.split('_')[1]);
                        checkedNodes.push({ PblVendorID: 0, Id: parseInt(locationNode.name.split('_')[1]) });
                    }
                }
            }
        }

        if (checkedNodes.length > 0) {
            $.ajax({
                url: "/Program/PrgBillableLocation/AssignPriceVendorsMapping?assign=false&parentId=" + programId,
                data: JSON.stringify(checkedNodes),
                async: true,
                type: "POST",
                contentType: "application/json",
                success: function (data) {
                    cplMapVendorPriceTreeViewPanel.PerformCallback();
                }
            });
        }
    };

    return {
        init: init,
        OnAddOrEdit: _onAddOrEdit,
        OnPopupAddOrEdit: _onPopupAddOrEdit,
        OnPopupCancel: _onPopupCancel,
        OnCancel: _onCancel,
        ClearErrorMessages: _clearErrorMessages,
        AssignProgramVendorMap: _onAssignProgramVendorMap,
        UnAssignProgramVendorMap: _onUnAssignProgramVendorMap,
        AssignProgramCostVendorMap: _onAssignProgramCostVendorMap,
        UnAssignProgramCostVendorMap: _onUnAssignProgramCostVendorMap,
        AssignProgramPriceVendorMap: _onAssignProgramPriceVendorMap,
        UnAssignProgramPriceVendorMap: _onUnAssignProgramPriceVendorMap,
        OnPopupUpdateJobGatewayComplete: _onPopupUpdateJobGatewayComplete,

    };
}();

M4PLWindow.ChooseColumns = function () {
    var params;

    var init = function (p) {
        params = p;
    };

    /// <summary>
    /// Fucntion for getting the selected items from given list control
    /// </summary>
    /// <param name="listControl">name of list to be evaluate</param>
    _getSelectedListItems = function (listControl) {
        var selectedItems = [];/*This will hold all the selected items of given listControl*/
        listControl.GetSelectedItems().forEach(function (currentItem) { selectedItems.push(currentItem.value); });
        return String(selectedItems);
    }

    /// <summary>
    /// Fucntion for updating the choose column values
    /// </summary>
    /// <param name="listControl">name of list to be evaluate</param>
    /// <param name="currentOperation">operation to be perform in callback</param>
    /// <param name="chooseColumnControl">choose column control</param>
    /// <param name="actionControllerArea">current actionControllerArea</param>
    _updateChooseColumnForm = function (listControl, currentOperation, chooseColumnControl, strRoute) {
        var availableColumnLastIndex = -1;
        if (ASPxClientControl.GetControlCollection().GetByName("lblShowColumns"))
            availableColumnLastIndex = ASPxClientControl.GetControlCollection().GetByName("lblShowColumns").GetSelectedIndices().pop();
        if (availableColumnLastIndex)
            availableColumnLastIndex = availableColumnLastIndex + 1;
        else
            availableColumnLastIndex = 0;
        if (!chooseColumnControl.InCallback())
            chooseColumnControl.PerformCallback({ selectedColumns: _getSelectedListItems(listControl), currentOperation: currentOperation, strRoute: strRoute, availableColumnLastIndex: availableColumnLastIndex });
    }

    _onShowColumnSelectedIndexChanged = function (s, e, allFreezedColumns, allRequiredFieldColumns, allGroupByColumns, isGroupingApplicable, allDefaultGroupByColumns) {
        var isGroupAvailable = (isGroupingApplicable == "True") ? true : false;
        var selectedItems = lblShowColumns.GetSelectedItems();/*This will hold all the selected items of given listControl*/
        var isItemSelected = (selectedItems.length > 0);
        var allRequiredFieldItems = (allRequiredFieldColumns != "") ? allRequiredFieldColumns.split(',') : [];
        var isGroupByItemSelected = false;
        var isNonGroupByItemSelected = false;
        var isDefaultGroupByItemSelected = false;
        var allDefaultGroupedItems = (allDefaultGroupByColumns != "") ? allDefaultGroupByColumns.split(',') : [];
        var allGroupedItems = (allGroupByColumns != "") ? allGroupByColumns.split(',') : [];
        if (isItemSelected) {
            lblAvailableColumns.SetSelectedItem(-1);
            AddColumn.SetEnabled(false);
            for (var i = 0; i < selectedItems.length; i++) {
                if (allRequiredFieldItems.indexOf(selectedItems[i].value) > -1)
                    isItemSelected = false;

                if (allDefaultGroupedItems.indexOf(selectedItems[i].value) > -1)
                    isDefaultGroupByItemSelected = true;

                if (allGroupedItems.indexOf(selectedItems[i].value) > -1)
                    isGroupByItemSelected = true;
                else
                    isNonGroupByItemSelected = true;
            }
        }
        RemoveColumn.SetEnabled(isItemSelected && !isGroupByItemSelected);/*Enable remove button if selected items count is greater then 0*/
        Freeze.SetEnabled((selectedItems.length > 0) && !isGroupByItemSelected);/*Enable freeze button if selected items count is greater then 0 AND No Group BY Items selected*/
        if (isGroupAvailable) {
            GroupBy.SetEnabled((selectedItems.length > 0) && !isGroupByItemSelected && !isDefaultGroupByItemSelected);/*Enable Group By button if selected items count is greater then 0  AND No Group BY Items selected */
            RemoveGroupBy.SetEnabled((selectedItems.length > 0) && !isNonGroupByItemSelected && !isDefaultGroupByItemSelected);/*Enable Remove Group By button if selected items count is greater then 0  AND only Group BY Items selected*/
        }

        if ((selectedItems.length > 0)) {
            var allFreezedItems = (allFreezedColumns != "") ? allFreezedColumns.split(',') : [];
            var isFreezedColumnAvailable = false;
            var isUnFreezeColumnAvailable = false;
            var isAnyUnFreezeColumnSelected = false;
            selectedItems.forEach(function (singleItem) {
                if (allFreezedItems.indexOf(singleItem.value) > -1)
                    isFreezedColumnAvailable = true;
                if (isFreezedColumnAvailable && !isUnFreezeColumnAvailable)
                    RemoveFreeze.SetEnabled(true)
                if (allFreezedItems.indexOf(singleItem.value) > -1) {
                    isFreezedColumnAvailable = true;
                    Freeze.SetEnabled(!isFreezedColumnAvailable);
                    if (isFreezedColumnAvailable && !isUnFreezeColumnAvailable)
                        RemoveFreeze.SetEnabled(true);
                }
                else {
                    isUnFreezeColumnAvailable = true;
                    RemoveFreeze.SetEnabled(false);
                }
            });



            if (isGroupByItemSelected && isNonGroupByItemSelected) { /*If selected items are available in both Grouped columns AND UnGrouped columns*/
                _disableUpAndDownBtn();
            } else if (isGroupByItemSelected && !isNonGroupByItemSelected) {
                if (allGroupedItems.length == 1) { /*If grouped item count is 1 then disable both buttons */
                    _disableUpAndDownBtn();
                } else {
                    Up.SetEnabled(selectedItems[0].index > 0); /*Enable up button if selected items first item index is greater then 0*/
                    Down.SetEnabled(selectedItems[selectedItems.length - 1].index < (allGroupedItems.length - 1)); /*Enable down button if selected items last item index is less then grouped column count - 1*/
                }
            } else if (isFreezedColumnAvailable && isUnFreezeColumnAvailable) { /*If selected items are available in both Freezed columns AND Unfreezed columns*/
                _disableUpAndDownBtn();
            } else if (isFreezedColumnAvailable) { /*If selected items are available in Freezed columns only*/
                if (allFreezedItems.length == 1) { /*If freezed item count is 1 then disable both buttons */
                    _disableUpAndDownBtn();
                } else {
                    Up.SetEnabled((selectedItems[0].index > allGroupedItems.length) && (selectedItems[0].index > 0)); /*If selected items first item index is greater then Group By Column Length AND greatr then 0 */
                    Down.SetEnabled(selectedItems[selectedItems.length - 1].index < (allFreezedItems.length - 1)); /*Enable down button if selected items last item index is less then freezed column count - 1*/
                }
            } else if (!isFreezedColumnAvailable && isUnFreezeColumnAvailable && !isGroupByItemSelected && isNonGroupByItemSelected) { /*If selected items are not available in Freezed columns/GroupBy Columns */
                Up.SetEnabled((selectedItems[0].index > (allFreezedItems.length + allGroupedItems.length)) && (selectedItems[0].index > 0)); /*If selected items first item index is greater then freezed column length + Group By Column Length AND greatr then 0 */
                Down.SetEnabled(selectedItems[selectedItems.length - 1].index < (lblShowColumns.itemsValue.length - 1)); /*If selected items last item index is less then total values length */
            }
        } else {
            _disableUpAndDownBtn();
        }
    }

    _disableUpAndDownBtn = function () {
        Up.SetEnabled(false);
        Down.SetEnabled(false);
    }

    /// <summary>
    /// Fucntion will get called on Show Column Initialization
    /// </summary>
    /// <param name="s"></param>
    /// <param name="e"></param>
    /// <param name="itemToSelect">value of item which needs to be selected after callback in ShowColumn listbox</param>
    _onShowColumnInit = function (s, e, itemsToSelect, allFreezedColumns, allGroupByColumns, allRequiredFieldColumns, isGroupingApplicable, allDefaultGroupByColumns) {
        window.setTimeout(function () {
            if (itemsToSelect != "") {
                var allItemsToSelect = [];
                var allItems = itemsToSelect.split(',');
                for (var i = 0; i < allItems.length; i++) {
                    var currentItemIndex = s.itemsValue.indexOf(allItems[i]);
                    if (currentItemIndex > -1) {
                        allItemsToSelect.push(s.GetItem(currentItemIndex));
                    }
                }
                if (allItemsToSelect.length > 0)
                    s.SelectItems(allItemsToSelect);
                _onShowColumnSelectedIndexChanged(undefined, undefined, allFreezedColumns, allRequiredFieldColumns, allGroupByColumns, isGroupingApplicable, allDefaultGroupByColumns);
            }
        }, 10);
    }

    _onAvailableColumnSelectedIndexChanged = function (s, e) {
        var _lblAvailableColumns = lblAvailableColumns.GetSelectedItems().length > 0;
        if (_lblAvailableColumns) {
            lblShowColumns.SetSelectedItem(-1);
            RemoveColumn.SetEnabled(!_lblAvailableColumns);
            Up.SetEnabled(!_lblAvailableColumns);
            Down.SetEnabled(!_lblAvailableColumns);
            Freeze.SetEnabled(!_lblAvailableColumns);
        }
        AddColumn.SetEnabled(_lblAvailableColumns);
    }

    /// <summary>
    /// Fucntion will be used by all the operation buttons except 'Save' and 'Cancel'
    /// </summary>
    /// <param name="s"></param>
    /// <param name="e"></param>
    /// <param name="listControl">name of list to be evaluate</param>
    _onDoOperation = function (s, e, listControl, chooseColumnControl, strRoute) {
        M4PLCommon.Control.OnTextChanged();//Calling this method here becuase If we are calling do operation it means we are updating the choose column related stuff.
        _updateChooseColumnForm(listControl, s.name, chooseColumnControl, strRoute);
    }

    /// <summary>
    /// Fucntion will Save the updated Choose Column Values
    /// </summary>
    /// <param name="s"></param>
    /// <param name="e"></param>
    /// <param name="form">name of the chooseColumnForm</param>
    /// <param name="strRoute">current string route</param>
    /// <param name="ownerPanel">callback Panel control</param>
    _onInsAndUpdChooseColumn = function (s, e, form, strRoute, ownerPanel, actionToAssign) {

        //To update FormViewHasChanges values
        M4PLCommon.Control.UpdateFormViewHasChangesWithDefaultValue();

        DevExCtrl.LoadingPanel.Show(GlobalLoadingPanel);
        $.ajax({
            type: "POST",
            url: $(form).attr("action"),
            success: function (response) {
                var currentRoute = JSON.parse(strRoute);
                if (currentRoute.Controller === "JobGateway") {
                    if (ASPxClientControl.GetControlCollection().GetByName("Gateways_JobDeliveryPageControl")) {
                        var index = ASPxClientControl.GetControlCollection().GetByName("Gateways_JobDeliveryPageControl").activeTabIndex;
                        switch (index) {
                            case 0:
                                actionToAssign = "JobGatewayAll";
                                break;
                            case 1:
                                actionToAssign = "JobGatewayDataView";
                                break;
                            case 2:
                                actionToAssign = "JobGatewayActions";
                                break;
                            case 3:
                                actionToAssign = "JobGatewayLog";
                                break;

                        }
                    }
                }
                currentRoute.Action = actionToAssign;
                if (currentRoute.Controller == "SecurityByRole") {

                    currentRoute.Action = 'FormView';
                    currentRoute.Entity = 26;
                    currentRoute.Area = "Organization";
                    currentRoute.RecordId = currentRoute.ParentRecordId;
                    currentRoute.Action = 'FormView';
                    currentRoute.EntityName = "Organization Reference Role";
                    currentRoute.Controller = "OrgRefRole";
                    currentRoute.ParentEntity = 19;
                    currentRoute.OwnerCbPanel = "AppCbPanel";
                    currentRoute.TabIndex = 0;
                }
                //currentRoute.IsPopup = false;
                if (ownerPanel && !ownerPanel.InCallback())
                    ownerPanel.PerformCallback({ strRoute: JSON.stringify(currentRoute) });
                DevExCtrl.LoadingPanel.Hide(GlobalLoadingPanel);
                RecordPopupControl.Hide();
            }
        });
    }

    return {
        init: init,
        DoOperation: _onDoOperation,/* This will be used by all the operation buttons except 'Save' and 'Cancel' */
        AvailableColumnSelectedIndexChanged: _onAvailableColumnSelectedIndexChanged,/* This will be used for AvailableColumnListBox selection change to make buttons enabled disabled */
        ShowColumnSelectedIndexChanged: _onShowColumnSelectedIndexChanged,/* This will be used for ShowColumnListBox selection change to make buttons enabled disabled */
        ShowColumnInit: _onShowColumnInit,/* This will be used by ShowColumnListBox on Init to select previously selected record */
        InsAndUpdChooseColumn: _onInsAndUpdChooseColumn,/* This will be used by 'Save' button */
    };
}();

M4PLWindow.DisplayMessage = function () {
    var params;

    var init = function (p) {
        params = p;
    };

    var _onDeleteConfirm = function (s, e, grid, popupFormView, AppCbPanel, pcDisplayMessage, systemUrl) {
        M4PLWindow.DataView.OnUpdateEditWithDelete(grid, e, AppCbPanel);
    }

    var _onCancel = function (s, e, popupFormView) {
    }

    var _onAcknowledge = function (s, e, popupFormView) {
    }

    return {
        init: init,
        Acknowledge: _onAcknowledge,
        Cancel: _onCancel,
        DeleteConfirm: _onDeleteConfirm,
    }
}();

M4PLWindow.UploadFileDragDrop = function () {

    var _init = function (s, e) {
        DevExCtrl.LoadingPanel.Show(GlobalLoadingPanel);
    }

    var _endCallback = function (s, e) {
        DevExCtrl.LoadingPanel.Hide(GlobalLoadingPanel);
    }

    var _onImportOrderRequest = function (s, e, route) {
        //AppCbPanel.PerformCallback({ strRoute: route });
        RecordPopupControl.PerformCallback({ strRoute: route });
        var importCtrl = ASPxClientControl.GetControlCollection().GetByName("pnlImportOrder");
        if (importCtrl != null) {
            importCtrl.PerformCallback({ strRoute: route });
        }
    }

    var _onUploadControlFileUploadComplete = function (s, e, callBackRoute) {
        if (e != null && e != undefined) {
            if (e.isValid)
                $("#uploadedImage").attr("src", e.callbackData);
            //_setElementVisible(s, e, "uploadedImage", e.isValid);
        }
        DevExCtrl.PopupControl.Close();
        ASPxClientControl.GetControlCollection().GetByName(callBackRoute.OwnerCbPanel).PerformCallback({ strRoute: JSON.stringify(callBackRoute) });
    }

    var _onImageLoad = function () {
        var externalDropZone = $("#externalDropZone");
        var uploadedImage = $("#uploadedImage");
        if (externalDropZone != null && externalDropZone != undefined && uploadedImage != null && uploadedImage != undefined) {
            uploadedImage.css({
                left: (externalDropZone.width() - uploadedImage.width()) / 2,
                top: (externalDropZone.height() - uploadedImage.height()) / 2
            });
            //_setElementVisible(externalDropZone, externalDropZone, "dragZone", false);
        }
    }

    var _setElementVisible = function (s, e, elementId, visible) {
        if (e.dropZone.id == 'externalDropZone') {
            if (elementId != null && elementId != undefined) {
                var el = $("#" + elementId);
                if (visible)
                    el.show();
                else
                    el.hide();
            }
        }
    }

    return {
        Init: _init,
        OnUploadControlFileUploadComplete: _onUploadControlFileUploadComplete,
        OnImageLoad: _onImageLoad,
        SetElementVisible: _setElementVisible,
        OnImportOrderRequest: _onImportOrderRequest,
        EndCallback: _endCallback
    }
}();
