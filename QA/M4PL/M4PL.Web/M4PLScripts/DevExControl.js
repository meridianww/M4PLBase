/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Kirty Anurag
//Date Programmed:                              10/10/2017
//Program Name:                                 DevExCtrl.js
//Purpose:                                      For implementing DevExCtrl client side logic throughout the application
//====================================================================================================================================================*/

var DevExCtrl = DevExCtrl || {};

DevExCtrl.Navbar = function () {
    var params;
    var init = function (p) {
        params = p;
    };

    var _itemClick = function (s, e) {
        if (!M4PLCommon.CheckHasChanges.CheckDataChanges()) {
            if (AppCbPanel && !AppCbPanel.InCallback()) {
                e.processOnServer = true;
                M4PLWindow.FormView.ClearErrorMessages();
                AppCbPanel.PerformCallback({ strRoute: e.item.name });
            }
        } else {
            M4PLCommon.CallerNameAndParameters = { "Caller": _itemClick, "Parameters": [s, e] };
            M4PLCommon.CheckHasChanges.ShowConfirmation();
        }
    }

    return {
        init: init,
        ItemClick: _itemClick
    }
}();

DevExCtrl.Ribbon = function () {
    var params;

    var init = function (p) {
        params = p;
    };
    var _onCommandExecuted = function (s, e, gridNameSuffix, appCbPanelName) {
        if (e.item.name == "") return;

        var route = JSON.parse(e.item.name);

        if ((route.EntityName === "Notepad") || (route.EntityName === "Calculator")) {
            M4PLCommon.WindowService.OnInitiateActionClick(M4PLCommon.WindowService.EnumCustomCommand[route.EntityName]);
            return;
        }

        if (route.EntityName === "Download Executor") {
            $.ajax({
                type: "GET",
                cache: false,
                url: "/Common/DownloadExecutorPath",
                contentType: 'application/json; charset=utf-8',
                success: function (response) {
                    window.location.href = window.location.href + response;
                }
            });
            return;
        }

        if ((route.Action === "Copy")) {
            var selectedText = M4PLCommon.Control.GetSelectedText();
            M4PLCommon.Clipboard.SetClipboard(selectedText);
            return;
        }
        if ((route.Action === "Cut")) {
            if (M4PLCommon.FocusedControlName) {
                var currentControl = ASPxClientControl.GetControlCollection().GetByName(M4PLCommon.FocusedControlName);
                if (currentControl.GetText() != "") {
                    var selectedText = M4PLCommon.Control.GetSelectedText();
                    M4PLCommon.Clipboard.SetClipboard(selectedText);
                    currentControl.SetText("");
                }
            }
            return;
        }

        if ((route.Action === "Paste")) {
            var inputcontrol;
            if (typeof window.prevFocus !== "undefined") {
                inputcontrol = window.prevFocus;

                if (inputcontrol != null && inputcontrol[0] != null) {
                    var str = inputcontrol[0].id;
                    var res = str.substring(0, str.lastIndexOf("_"));
                    if (ASPxClientControl.GetControlCollection().GetByName(res) == null) {
                        M4PLCommon.Clipboard.GetClipboard(inputcontrol[0], true)
                    }
                    else {
                        M4PLCommon.Clipboard.GetClipboard(inputcontrol[0], false)
                    }
                }
            }
            return;
        }

        if (route.Controller === "Program" && route.Action === "Create") {
            DevExCtrl.TreeView.AddProgram(s, e, ProgramTree);
            return;
        }

        if (route.RecordId <= 0) {
            var currentGrid = ASPxClientControl.GetControlCollection().GetByName(route.Controller + gridNameSuffix);
            if (currentGrid)
                route.RecordId = Number(currentGrid.GetRowKey(currentGrid.GetFocusedRowIndex()));
        }

        if (route.Controller === "Job") {
            switch (route.Action) {
                case "Create":
                    route.RecordId = 0;
                    M4PLJob.FormView.CreateJobFromRibbon(s, e, route);
                    return;
                case "FormView":
                    M4PLJob.FormView.FormViewJobFromRibbon(s, e, route);
                    return;
                case "DataView":
                    M4PLJob.FormView.DataViewJobFromRibbon(s, e, route);
                    return;
                case "ChooseColumns":
                    appCbPanelName = "JobDataViewCbPanel";
                    route.ParentRecordId = parseInt(TreeList.GetFocusedNodeKey());
                    route.ParentEntity = "Program";
                    break;
            }
        }

        if (route.Controller === "PrgEdiHeader") {
            switch (route.Action) {
                case "Create":
                    route.RecordId = 0;
                    DevExCtrl.EdiHeader.CreateEdiHeaderFromRibbon(s, e, route);
                    return;
                case "FormView":
                    DevExCtrl.EdiHeader.FormViewEdiHeaderFromRibbon(s, e, route);
                    return;
                case "DataView":
                    DevExCtrl.EdiHeader.DataViewEdiHeaderFromRibbon(s, e, route);
                    return;
            }
        }

        if (!M4PLCommon.CheckHasChanges.CheckDataChanges() || (route.Action === "Save")) {
            switch (route.Action) {
                case "FormView":
                    if (route.EntityName == "NAV Rate" || route.EntityName == "Gateway")
                        RecordPopupControl.PerformCallback({ strRoute: JSON.stringify(route) });
                    else {
                        if (AppCbPanel && !AppCbPanel.InCallback()) {
                            route.OwnerCbPanel = appCbPanelName;
                            AppCbPanel.PerformCallback({ strRoute: JSON.stringify(route) });
                        }
                        _doCallBack(route);
                    }
                    break;
                case "DataView":
                case "Dashboard":
                    if (AppCbPanel && !AppCbPanel.InCallback()) {
                        route.OwnerCbPanel = appCbPanelName;
                        AppCbPanel.PerformCallback({ strRoute: JSON.stringify(route) });
                    }
                    _doCallBack(route);
                    break;

                case "SyncPurchasePricesDataFromNav":
                case "SyncSalesPricesDataFromNav":
                case "SyncOrderDetailsInNAV":
                    DevExCtrl.LoadingPanel.Show(GlobalLoadingPanel)
                    M4PLCommon.InformationPopup.NAVSyncSuccessResponse(route.Url);
                    break;

                case "ChooseColumns":
                    route.OwnerCbPanel = appCbPanelName; //This OwnerCbPanel assigning for Choose Column Functionality so that can do callback of given cbpanel.

                    RecordPopupControl.PerformCallback({ strRoute: JSON.stringify(route) });
                    break;
                case "ExportExcel":
                case "ExportPdf":
                    window.location = route.Url + "?strRoute=" + JSON.stringify(route);
                    break;
                case "DownloadAll":
                    var jobIds = _onJobReportClickMultiSelect();
                    route = _onJobReportClick(route);
                    if ((jobIds !== null && jobIds !== '') || (route.RecordId != null && route.RecordId > 0))
                        var result = M4PLCommon.DocumentStatus.IsAttachmentPresentForJob(route.RecordId, jobIds);
                    else
                        M4PLCommon.Error.InitDisplayMessage("Business Rule", "Please select specific any row");
                    if (result == true) {
                        window.location = route.Url + "?strRoute=" + JSON.stringify(route) + '&jobIds=' + jobIds;
                    }
                    else {
                        M4PLCommon.DocumentStatus.DisplayMessage("Business Rule", "Please select specific any row", 2, 'JobDocumentPresent');
                    }
                    break;
                case "WatchVideo":
                    window.open(window.location.origin + "/m4pltraining");
                    break;
                case "TrackingOrder":
                    var newRoute = _onJobReportClick(route);
                    if (newRoute != null && newRoute != "undefined" && newRoute.RecordId != 'undefined' && newRoute.RecordId > 0) {
                        //window.open("http://localhost:4200" + "/orderdetails;id=" + newRoute.RecordId);
                        window.open(window.location.origin + "/tracking/orderdetails;id=" + newRoute.RecordId);
                    }
                        //else if ((route.EntityName == 'Job' || route.EntityName == 'JobAdvanceReport' || route.EntityName == 'JobCard')) {
                        //    var id = ASPxClientControl.GetControlCollection().GetByName("Id");
                        //    if (id != null && id != undefined && id.GetValue() != undefined && id.GetValue() > 0)
                        //        window.open("http://localhost:4200" + "/orderdetails;id=" + id.GetValue());
                        //}
                    else
                        //window.open("http://localhost:4200" + "/order");
                        window.open(window.location.origin + "/tracking/order");
                    break;
                case "DownloadBOL":
                    var jobIds = _onJobReportClickMultiSelect();
                    route = _onJobReportClick(route);
                    if ((jobIds !== null && jobIds !== '') || (route.RecordId != null && route.RecordId > 0))
                        window.location = route.Url + "?strRoute=" + JSON.stringify(route) + '&jobIds=' + jobIds;
                    else
                        M4PLCommon.Error.InitDisplayMessage("Business Rule", "Please select specific any row");
                    break;
                case "DownloadPOD":
                    var jobIds = _onJobReportClickMultiSelect();
                    route = _onJobReportClick(route);
                    if ((jobIds !== null && jobIds !== '') || (route.RecordId != null && route.RecordId > 0))
                        var result = M4PLCommon.DocumentStatus.IsPODAttachedForJob(route.RecordId, jobIds);
                    else
                        M4PLCommon.Error.InitDisplayMessage("Business Rule", "Please select specific any row");
                    if (result == true) {
                        window.location = route.Url + "?strRoute=" + JSON.stringify(route) + '&jobIds=' + jobIds;
                    }
                    else {
                        M4PLCommon.DocumentStatus.PODMissingDisplayMessage("Business Rule", "Please select specific any row");
                    }
                    break;
                case "DownloadTracking":
                    var jobIds = _onJobReportClickMultiSelect();
                    route = _onJobReportClick(route);
                    if ((jobIds !== null && jobIds !== '') || (route.RecordId != null && route.RecordId > 0))
                        window.location = route.Url + "?strRoute=" + JSON.stringify(route) + '&jobIds=' + jobIds;
                    else
                        M4PLCommon.Error.InitDisplayMessage("Business Rule", "Please select specific any row");
                    break;
                case "DownLoadPurchaseLinePriceFromNav":
                    var jobIds = _onJobReportClickMultiSelect();
                    route = _onJobReportClick(route);
                    if ((jobIds !== null && jobIds !== '') || (route.RecordId != null && route.RecordId > 0))
                        var result = M4PLCommon.DocumentStatus.IsPriceCodeDataPresentForJobInNAV(route.RecordId, jobIds);
                    else
                        M4PLCommon.Error.InitDisplayMessage("Business Rule", "Please select specific any row");

                    if (result == true) {
                        window.location = route.Url + "?strRoute=" + JSON.stringify(route) + '&jobIds=' + jobIds;
                    }
                    else {
                        M4PLCommon.DocumentStatus.JobPriceCodeMissingDisplayMessage("Business Rule", "Please select specific any row");
                    }
                    break;
                case "DownLoadSalesLineCostFromNav":
                    var jobIds = _onJobReportClickMultiSelect();
                    route = _onJobReportClick(route);
                    if ((jobIds !== null && jobIds !== '') || (route.RecordId != null && route.RecordId > 0))
                        var result = M4PLCommon.DocumentStatus.IsCostCodeDataPresentForJobInNAV(route.RecordId, jobIds);
                    else
                        M4PLCommon.Error.InitDisplayMessage("Business Rule", "Please select specific any row");
                    if (result == true) {
                        window.location = route.Url + "?strRoute=" + JSON.stringify(route) + '&jobIds=' + jobIds;
                    }
                    else {
                        M4PLCommon.DocumentStatus.JobCostCodeMissingDisplayMessage("Business Rule", "Please select specific any row");
                    }
                    break;
                case "DownloadPriceReport":
                    var jobIds = _onJobReportClickMultiSelect();
                    route = _onJobReportClick(route);
                    if ((jobIds !== null && jobIds !== '') || (route.RecordId != null && route.RecordId > 0))
                        var result = M4PLCommon.DocumentStatus.IsPriceCodeDataPresentForJob(route.RecordId, jobIds);
                    else
                        M4PLCommon.Error.InitDisplayMessage("Business Rule", "Please select specific any row");

                    if (result == true) {
                        window.location = route.Url + "?strRoute=" + JSON.stringify(route) + '&jobIds=' + jobIds;
                    }
                    else {
                        M4PLCommon.DocumentStatus.JobPriceCodeMissingDisplayMessage("Business Rule", "Please select specific any row");
                    }
                    break;
                case "DownloadCostReport":
                    var jobIds = _onJobReportClickMultiSelect();
                    route = _onJobReportClick(route);
                    if ((jobIds !== null && jobIds !== '') || (route.RecordId != null && route.RecordId > 0))
                        var result = M4PLCommon.DocumentStatus.IsCostCodeDataPresentForJob(route.RecordId, jobIds);
                    else
                        M4PLCommon.Error.InitDisplayMessage("Business Rule", "Please select specific any row");
                    if (result == true) {
                        window.location = route.Url + "?strRoute=" + JSON.stringify(route) + '&jobIds=' + jobIds;
                    }
                    else {
                        M4PLCommon.DocumentStatus.JobCostCodeMissingDisplayMessage("Business Rule", "Please select specific any row");
                    }
                    break;
                case "DownloadJobHistoryReport":
                    var jobIds = _onJobReportClickMultiSelect();
                    route = _onJobReportClick(route);
                    if ((jobIds !== null && jobIds !== '') || (route.RecordId != null && route.RecordId > 0))
                        var result = M4PLCommon.DocumentStatus.IsHistoryPresentForJob(route.RecordId, jobIds);
                    else
                        M4PLCommon.Error.InitDisplayMessage("Business Rule", "Please select specific any row");
                    if (result == true) {
                        window.location = route.Url + "?strRoute=" + JSON.stringify(route) + '&jobIds=' + jobIds;
                    }
                    else {
                        M4PLCommon.DocumentStatus.JobHistoryMissingDisplayMessage("Business Rule", "Please select specific any row");
                    }
                    break;
                default:
                    if (route.Action === "Create" && (route.Controller === "OrgRefRole")) {
                        switch (route.Action) {
                            case "Create":
                                route.RecordId = 0;
                                break;
                        }
                    }
                    _onFilterClicked(s, e, route, appCbPanelName, gridNameSuffix);
                    break;
            }
        } else {
            M4PLCommon.CallerNameAndParameters = { "Caller": _onCommandExecuted, "Parameters": [s, e, gridNameSuffix, appCbPanelName] };
            M4PLCommon.CheckHasChanges.ShowConfirmation();
        }
    }

    var _doCallBack = function (route) {
        // M4PLRibbon.SetVisible((route.Action != "Dashboard"));
        if (typeof RibbonCbPanel !== 'undefined' && !RibbonCbPanel.InCallback()) {
            route.OwnerCbPanel = "RibbonCbPanel";
            RibbonCbPanel.PerformCallback({ strRoute: JSON.stringify(route) });
        }
        else {
            if (route != null && route != undefined) {
                var ctrl = ASPxClientControl.GetControlCollection().GetByName(route.OwnerCbPanel);
                if (ctrl != null && ctrl != undefined) {
                    ctrl.PerformCallback({ strRoute: JSON.stringify(route) });
                }
            }
        }
        M4PLCommon.Error.CheckServerError();
    }

    var _onFilterClicked = function (s, e, route, ownerCbPanel, gridNameSuffix) {
        $.ajax({
            type: "POST",
            url: route.Url,
            data: { strRoute: JSON.stringify(route) },
            success: function (response) {
                if (response && response.status === true) {
                    if (response.isSyncOutlook) {
                        // debugger;
                        M4PLCommon.WindowService.OnSyncOutlookClick(response.authToken, response.addContactBaseUrl, response.statusIdToAssign);
                    }
                    if (response.ownerName) {
                        if (ASPxClientControl.GetControlCollection().GetByName(response.ownerName) && !ASPxClientControl.GetControlCollection().GetByName(response.ownerName).InCallback())
                            if (response.route) {
                                switch (response.route.Action) {
                                    case "AdvancedSortFilter":
                                        if (response.route.Controller == "JobAdvanceReport")
                                            response.route.EntityName = response.route.Controller;
                                        var currentGrid = ASPxClientControl.GetControlCollection().GetByName(response.route.Controller + gridNameSuffix);
                                        //currentGrid.SetFilterEnabled(true);
                                        currentGrid.ShowFilterControl();
                                        break;
                                    case "ToggleFilter":
                                        if (response.route.Controller === "Job" || response.route.Controller === "PrgEdiHeader") {
                                            M4PLJob.FormView.DataViewJobFromRibbon(s, e, route);
                                            return;
                                        }
                                        response.route.Action = "DataView";
                                        if (ownerCbPanel && ownerCbPanel !== '') {
                                            if (response.shouldUpdateCurrentRoute)
                                                route = response.route;
                                            route.Action = "DataView";
                                            ASPxClientControl.GetControlCollection().GetByName(ownerCbPanel).PerformCallback({ strRoute: JSON.stringify(route) });
                                        }
                                        else {
                                            ASPxClientControl.GetControlCollection().GetByName(response.ownerName)[response.callbackMethod]({ strRoute: JSON.stringify(response.route) });
                                            _doCallBack(response.route);
                                        }
                                        break;
                                    default:
                                        ASPxClientControl.GetControlCollection().GetByName(response.ownerName)[response.callbackMethod]({ strRoute: response.route });
                                        _doCallBack(JSON.parse(response.route));
                                        break;
                                }
                            } else
                                ASPxClientControl.GetControlCollection().GetByName(response.ownerName)[response.callbackMethod]();
                    }
                }
            }
        });
    }

    var _onJobReportClick = function (route) {
        var gridCtrl = null;
        if (ASPxClientControl.GetControlCollection().GetByName("JobGridView") != null) {
            gridCtrl = ASPxClientControl.GetControlCollection().GetByName("JobGridView");
        }
        else if (ASPxClientControl.GetControlCollection().GetByName("JobAdvanceReportGridView") != null) {
            gridCtrl = ASPxClientControl.GetControlCollection().GetByName("JobAdvanceReportGridView");
        }
        else if (ASPxClientControl.GetControlCollection().GetByName("JobCardGridView") != null) {
            gridCtrl = ASPxClientControl.GetControlCollection().GetByName("JobCardGridView");
        }

        if (gridCtrl != null) {
            var selectedIndex = gridCtrl.GetFocusedRowIndex();
            if (selectedIndex >= 0) {
                var ketValue = gridCtrl.GetItemKey(selectedIndex)
                route.RecordId = ketValue != null && ketValue > 0 ? ketValue : route.RecordId;
            }
        }

        return route;
    }

    var _onJobReportClickMultiSelect = function () {
        var jobIds = '';
        var s = ASPxClientControl.GetControlCollection().GetByName("JobGridView");
        if (s != null && s != undefined) {
            if (s.GetSelectedKeysOnPage() != undefined && s.GetSelectedKeysOnPage().length > 0) {
                jobIds = s.GetSelectedKeysOnPage().join();
            }
        }

        return jobIds;
    }

    return {
        init: init,
        OnCommandExecuted: _onCommandExecuted,
        OnFilterClicked: _onFilterClicked,
        DoCallBack: _doCallBack
    }
}();

DevExCtrl.TextBox = function () {
    var params;

    var init = function (p) {
        params = p;
    };

    var _onTextChange = function (s, e, nextCtrl, startIndex, lastIndex, divClass) {
        var value = s.GetValue() || '';
        if (value.length == 0) {
            while (parseInt(startIndex) < parseInt(lastIndex)) {
                $('.' + divClass + startIndex).removeClass("pointer-event-auto").addClass("pointer-event-none");
                startIndex++;
            }
        } else {
            $('.' + nextCtrl).removeClass("pointer-event-none").addClass("pointer-event-auto");
        }
    }

    var _onCustBTThresholdValueChanged = function (s, e, hiThresholdControl, lowThresholdControl, currentThresholdPercentage) {
        var currentThresholdValue = s.GetValue();
        if (ASPxClientControl.GetControlCollection().GetByName(hiThresholdControl))
            ASPxClientControl.GetControlCollection().GetByName(hiThresholdControl).SetValue((currentThresholdValue > 0) ? (currentThresholdValue + (currentThresholdValue * currentThresholdPercentage / 100)) : 0);
        if (ASPxClientControl.GetControlCollection().GetByName(lowThresholdControl))
            ASPxClientControl.GetControlCollection().GetByName(lowThresholdControl).SetValue((currentThresholdValue > 0) ? (currentThresholdValue - (currentThresholdValue * currentThresholdPercentage / 100)) : 0);
    }

    var _onVendBTThresholdValueChanged = function (s, e, hiThresholdControl, lowThresholdControl, currentThresholdPercentage) {
        var currentThresholdValue = s.GetValue();
        if (ASPxClientControl.GetControlCollection().GetByName(hiThresholdControl))
            ASPxClientControl.GetControlCollection().GetByName(hiThresholdControl).SetValue((currentThresholdValue > 0) ? (currentThresholdValue + (currentThresholdValue * currentThresholdPercentage / 100)) : 0);
        if (ASPxClientControl.GetControlCollection().GetByName(lowThresholdControl))
            ASPxClientControl.GetControlCollection().GetByName(lowThresholdControl).SetValue((currentThresholdValue > 0) ? (currentThresholdValue - (currentThresholdValue * currentThresholdPercentage / 100)) : 0);
    }

    var _showHidePasswordOpnSezme = function (pwdCtrl) {
        var inputType = $("#" + pwdCtrl).attr("type");
        if (inputType == "password") {
            $("#" + pwdCtrl).get(0).type = "text";
        } else if (inputType == "text") {
            $("#" + pwdCtrl).get(0).type = "password";
        }
    }

    var _keyPressProgramItemCtrl = function (s, e) {
        var regex = new RegExp("^[0-9.]*$");
        if (!regex.test(e.htmlEvent.key)) {
            ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
            return false;
        }
    }

    var _onCustVendBTThresholdValueChangedBatchEdit = function (s, e, gridCtrl, hiThresholdControl, lowThresholdControl, currentThresholdPercentage) {
        var currentThresholdValue = s.GetValue();
        if (gridCtrl.GetColumnByField(hiThresholdControl) != null)
            gridCtrl.SetEditValue(hiThresholdControl, (currentThresholdValue > 0) ? (currentThresholdValue + (currentThresholdValue * (currentThresholdPercentage / 100))) : 0);
        if (gridCtrl.GetColumnByField(lowThresholdControl) != null)
            gridCtrl.SetEditValue(lowThresholdControl, (currentThresholdValue > 0) ? (currentThresholdValue - (currentThresholdValue * (currentThresholdPercentage / 100))) : 0);
    }

    return {
        init: init,
        OnTextChange: _onTextChange,
        OnCustBTThresholdValueChanged: _onCustBTThresholdValueChanged,
        OnVendBTThresholdValueChanged: _onVendBTThresholdValueChanged,
        ShowHidePasswordOpnSezme: _showHidePasswordOpnSezme,
        KeyPressProgramItemCtrl: _keyPressProgramItemCtrl,
        OnCustVendBTThresholdValueChangedBatchEdit: _onCustVendBTThresholdValueChangedBatchEdit,
    }
}();

DevExCtrl.ComboBox = function () {
    var _selectedIndexChanged = function (s, e) {
    }

    var _rateTypeChange = function (s, e, isPopup, element) {
        var elements = ASPxClientControl.GetControlCollection().GetByName((isPopup && (isPopup === "True")) ? (element + "_popup") : element);
        if (elements)
            elements.SetVisible(s.GetValue() === 109);
    }

    var _valueChangedTable = function (s, e, columnCtrl, columnDropDown) {
        if (columnCtrl) {
            columnDropDown.ParentCondition = s.GetValue();
            columnCtrl.PerformCallback({ strDropDownViewModel: JSON.stringify(columnDropDown) });
        }
    }

    var _dropDownBeginCallBack = function (s, e, dropDownViewModel, parentControl) {
        if (parentControl && (ASPxClientControl.GetControlCollection().GetByName(parentControl) != null)) {
            dropDownViewModel.ParentCondition = ASPxClientControl.GetControlCollection().GetByName(parentControl).GetValue();
        }
        if (dropDownViewModel != null && dropDownViewModel != undefined) {
            if (dropDownViewModel.ControlName == "JobDeliveryState") {
                var ctrlCountry = ASPxClientControl.GetControlCollection().GetByName("JobDeliveryCountry");
                if (ctrlCountry != null && ctrlCountry != undefined) {
                    dropDownViewModel.SelectedCountry = ctrlCountry.GetValue();
                }
            }
            if (dropDownViewModel.ControlName == "JobOriginState") {
                var ctrlCountry = ASPxClientControl.GetControlCollection().GetByName("JobOriginCountry");
                if (ctrlCountry != null && ctrlCountry != undefined) {
                    dropDownViewModel.SelectedCountry = ctrlCountry.GetValue();
                }
            }
        }
        e.customArgs["strDropDownViewModel"] = JSON.stringify(dropDownViewModel);
    }

    var _valueChangedColumn = function (s, e, lookupCtrl, lookupDropDown) {
        if (lookupCtrl && s.GetSelectedItem().GetColumnText("DataType")) {
            var disabled = s.GetSelectedItem().GetColumnText("DataType") === "int";
            lookupDropDown.Disabled = !disabled;
            lookupCtrl.SetEnabled(disabled);
            if (s.GetSelectedItem().GetColumnText("LookupName")) {
                lookupCtrl.ParentCondition = s.GetSelectedItem().GetColumnText("LookupName")
                lookupCtrl.PerformCallback({ strDropDownViewModel: JSON.stringify(lookupDropDown) });
            }
        }
    }

    var _valueChangedReport = function (s, e, rprtVwrCtrl, rprtVwrRoute) {
        if (rprtVwrCtrl) {
            rprtVwrRoute.RecordId = s.GetValue() || 0;
            rprtVwrCtrl.PerformCallback({ strRoute: JSON.stringify(rprtVwrRoute) });
        }
    }

    var _valueChangedDashboard = function (s, e, dboardVwrCtrl, dboardVwrRoute) {
        if (dboardVwrCtrl) {
            dboardVwrRoute.RecordId = s.GetValue() || 0;
            dboardVwrCtrl.PerformCallback({ strRoute: JSON.stringify(dboardVwrRoute) });
        }
    }

    var _valueChangeMenuModule = function (s, e, bdsUrl, bdsCtrl, rbnCtrl) {
        if (bdsCtrl && rbnCtrl) {
            if (s.GetSelectedItem() == null) {
                $.ajax({
                    url: bdsUrl + "?module=" + s.GetValue() + "&isRibbon=" + rbnCtrl.GetValue(),
                    type: "GET",
                    success: function (data) {
                        bdsCtrl.SetValue(data);
                    }
                });
            } else {
                if (rbnCtrl.GetValue())
                    bdsCtrl.SetValue(s.GetSelectedItem().texts[2]);
                else
                    bdsCtrl.SetValue(s.GetSelectedItem().texts[1]);
            }

            //if (rbnCtrl.GetValue())
            //    bdsCtrl.SetValue(s.GetSelectedItem().texts[2]);
            //else
            //    bdsCtrl.SetValue(s.GetSelectedItem().texts[1]);

            //$.ajax({
            //    url: bdsUrl + "?moduleId=" + s.GetValue() + "&isRibbon=" + rbnCtrl.GetValue(),
            //    type: "GET",
            //    success: function (data) {
            //        bdsCtrl.SetValue(data);
            //    }
            //});
        }
    }

    var _valueChangedColAliasTable = function (s, e, gridCbPanel, tableCtrl, route) {
        if (gridCbPanel) {
            route.Filters = {};
            route.Filters.FieldName = tableCtrl;
            route.Filters.Value = s.GetValue();
            if (gridCbPanel && !gridCbPanel.InCallback()) {
                gridCbPanel.PerformCallback({ strRoute: JSON.stringify(route) });
            }
        }
    }

    var _onBeginCallbackFilterTextFormat = function (s, e) {
        //e.customArgs["textFormat" + s.name] = document.getElementById("textFormat" + s.name).value;
    }
    var _onComboBoxInit = function (s, e) {
        ASPxClientUtils.AttachEventToElement(document, "scroll", function (evt) {
            if (ASPx.GetDropDownCollection().IsEventNotFromControlSelf(evt, s)) {
                s.HideDropDown();
            }
        });
    }

    //cascading Combobox load Start

    var _onTableCombo_SelectedIndexChanged = function (s, e, grid, field) {
        grid.GetEditor(field).PerformCallback();
    }

    function _onColumnCombo_BeginCallback(s, e, grid, field) {
        e.customArgs["strEntity"] = grid.GetEditor(field).GetValue();
    }

    function _onMnuClassification_BeginCallback(s, e, grid, field, menuLookupId, RibbonLookupId) {
        if (grid.GetEditor(field).GetValue()) {
            menuLookupId = RibbonLookupId;
        }
        e.customArgs["lookupId"] = menuLookupId;
    }

    var _onPrgGatewayLostFocus = function EdiHeaderRadioLostFocus(gridCtrl) {
        gridCtrl.batchEditApi.EndEdit();
    }

    var _onProgramRefRoleChange = function (s, e) {
        if (ProgramRoleLogicalCbPanel && !ProgramRoleLogicalCbPanel.InCallback()) {
            ProgramRoleLogicalCbPanel.PerformCallback({ id: s.GetValue() || 0 });
        }

        if (ProgramRoleCodesCbPanel && !ProgramRoleCodesCbPanel.InCallback()) {
            ProgramRoleCodesCbPanel.PerformCallback({ id: s.GetValue() || 0 });
        }
    };
    var _onCustomerLocationCbPanelChange = function (s, e) {
        if (CustomerLocationCbPanel && !CustomerLocationCbPanel.InCallback()) {
            CustomerLocationCbPanel.PerformCallback({ id: s.GetValue() || -1 });
        }
    };

    var _onCustomerCardTileCbPanelChange = function (s, e, rprtVwrCtrl, rprtVwrRoute) {
        rprtVwrRoute.Location = null;
        var customerId = s.GetValue();
        if (DestinationByProgramCustomerCbPanel && !DestinationByProgramCustomerCbPanel.InCallback()) {
            DestinationByProgramCustomerCbPanel.PerformCallback({ id: customerId || -1 });
        }

        DevExCtrl.LoadingPanel.Show(GlobalLoadingPanel);
        rprtVwrRoute.RecordId = customerId || 0;
        rprtVwrCtrl.PerformCallback({ strRoute: JSON.stringify(rprtVwrRoute) });
    };

    var _onInitProgramRoleCode = function (s, e, prgRoleCodeCtrl, codeValue) {
        if (prgRoleCodeCtrl && codeValue.trim().length > 0)
            prgRoleCodeCtrl.SetText(codeValue);
    };

    var _onCustomHighlighting = function (s, e) {
        e.highlighting = new RegExp(e.filter.toLowerCase(), "gi");
    }

    var _onProgramByCustomerCbPanelChange = function (s, e) {
        var reportTypeCtrl = ASPxClientControl.GetControlCollection().GetByName('ReportType');
        var customerCtrl = ASPxClientControl.GetControlCollection().GetByName('Customer');
        if (reportTypeCtrl != null &&
            ((reportTypeCtrl.GetText() == "Driver Scrub Report"))
            || (reportTypeCtrl.GetText() == "Capacity Report")
            || (reportTypeCtrl.GetText() == "Pride Metric Report")) {
            if (reportTypeCtrl.GetText() != "Pride Metric Report") {
                if (customerCtrl != null && customerCtrl.GetText() != "ALL" && parseInt(customerCtrl.GetValue()) > 0) {
                    $(".isDriverImport").show();
                    $(".isDriverbtnScrubreport").show();
                    var btnReportCtrl = ASPxClientControl.GetControlCollection().GetByName('btnImportReport');
                    if (btnReportCtrl != null && btnReportCtrl != undefined) {
                        if (reportTypeCtrl.GetText() == "Driver Scrub Report")
                            btnReportCtrl.SetText("Import Scrub Driver");
                        else if (reportTypeCtrl.GetText() == "Capacity Report")
                            btnReportCtrl.SetText("Import Projected Capacity");
                        else
                            btnReportCtrl.SetText("Import Report");
                    }
                } else {
                    $(".isDriverImport").hide();
                    $(".isDriverbtnScrubreport").hide();
                }
            }
        }
        else {
            if (ProgramByCustomerCbPanel && !ProgramByCustomerCbPanel.InCallback()) {
                ProgramByCustomerCbPanel.PerformCallback({ id: s.GetValue() || -1 });
            }
            if (OrginByCustomerCbPanel && !OrginByCustomerCbPanel.InCallback()) {
                OrginByCustomerCbPanel.PerformCallback({ id: s.GetValue() || -1 });
            }
            if (DestinationByProgramCustomerCbPanel && !DestinationByProgramCustomerCbPanel.InCallback()) {
                DestinationByProgramCustomerCbPanel.PerformCallback({ id: s.GetValue() || -1 });
            }
            if (BrandByCustomerProgramCbPanel && !BrandByCustomerProgramCbPanel.InCallback()) {
                BrandByCustomerProgramCbPanel.PerformCallback({ id: s.GetValue() || -1 });
            }
            if (GatewayStatusIdByCustomerProgramCbPanel && !GatewayStatusIdByCustomerProgramCbPanel.InCallback()) {
                GatewayStatusIdByCustomerProgramCbPanel.PerformCallback({ id: s.GetValue() || -1 });
            }
            if (ServiceModeByCustomerCbPanel && !ServiceModeByCustomerCbPanel.InCallback()) {
                ServiceModeByCustomerCbPanel.PerformCallback({ id: s.GetValue() || -1 });
            }
            if (ProductTypeByCustomerCbPanel && !ProductTypeByCustomerCbPanel.InCallback()) {
                ProductTypeByCustomerCbPanel.PerformCallback({ id: s.GetValue() || -1 });
            }
            if (JobChannelByProgramCustomerCbPanel && !JobChannelByProgramCustomerCbPanel.InCallback()) {
                JobChannelByProgramCustomerCbPanel.PerformCallback({ id: s.GetValue() || -1 });
            }
        }
    };
    return {
        OnComboBoxInit: _onComboBoxInit,
        SelectedIndexChanged: _selectedIndexChanged,
        ValueChangedTable: _valueChangedTable,
        ValueChangedColumn: _valueChangedColumn,
        ValueChangedReport: _valueChangedReport,
        ValueChangedDashboard: _valueChangedDashboard,
        ValueChangeMenuModule: _valueChangeMenuModule,
        ProgramBillOnSelectedIndexChanged: _rateTypeChange,
        DropDownBeginCallBack: _dropDownBeginCallBack,
        ValueChangedColAliasTable: _valueChangedColAliasTable,
        BeginCallbackFilterTextFormat: _onBeginCallbackFilterTextFormat,
        TableCombo_SelectedIndexChanged: _onTableCombo_SelectedIndexChanged,
        ColumnCombo_BeginCallback: _onColumnCombo_BeginCallback,
        MnuClassification_BeginCallback: _onMnuClassification_BeginCallback,
        PrgGatewayLostFocus: _onPrgGatewayLostFocus,
        ProgramRefRoleChange: _onProgramRefRoleChange,
        OnInitProgramRoleCode: _onInitProgramRoleCode,
        OnCustomHighlighting: _onCustomHighlighting,
        CustomerLocationCbPanelChange: _onCustomerLocationCbPanelChange,
        CustomerCardTileCbPanelChange: _onCustomerCardTileCbPanelChange,
        ProgramByCustomerCbPanelChange: _onProgramByCustomerCbPanelChange,
    };
}();

DevExCtrl.TreeView = function () {
    var init = function (s, e) {
    };

    var _nodeClick = function (s, e) {
        if (!M4PLCommon.CheckHasChanges.CheckDataChanges()) {
            _setBreadCrumb(e.node);
            if (e.node.parent !== null) {
                var route = {}
                route.ParentRecordId = 0;
                route.OwnerCbPanel = _findCustomerCode(e.node.parent);
                route.Filters = {};
                var nodeName = e.node.name.split('_');
                route.RecordId = parseFloat(nodeName[(nodeName.length - 1)]);
                route.Filters.FieldName = e.node.name;
                var customerCode = _findCustomerCode(e.node.parent);

                if (cplTreeView && !cplTreeView.InCallback()) {
                    e.processOnServer = true;
                    cplTreeView.PerformCallback({ strRoute: JSON.stringify(route) });
                    var ribbonRoute = route;
                    ribbonRoute.Action = "RibbonMenu";
                    ribbonRoute.EntityName = "Common";
                    DevExCtrl.Ribbon.DoCallBack(ribbonRoute);
                }
            }
        } else {
            M4PLCommon.CallerNameAndParameters = { "Caller": _nodeClick, "Parameters": [s, e] };
            M4PLCommon.CheckHasChanges.ShowConfirmation();
        }
    };

    var _addProgram = function (s, e, treeView) {
        if (!M4PLCommon.CheckHasChanges.CheckDataChanges()) {
            var selectedNode = treeView.GetSelectedNode();
            if (selectedNode !== null) {
                var route = {}
                route.ParentRecordId = 0;
                route.OwnerCbPanel = _findCustomerCode(selectedNode);
                route.RecordId = 0;
                route.Filters = {};

                var customerId = 0;
                var nodename = selectedNode.name.split("_");
                if (selectedNode.parent === null) {
                    route.Filters.FieldName = "CustomerId";
                    route.Filters.Value = nodename[nodename.length - 1];
                } else {
                    route.ParentRecordId = nodename[nodename.length - 1];
                }

                if (cplTreeView && !cplTreeView.InCallback()) {
                    e.processOnServer = true;
                    cplTreeView.PerformCallback({ strRoute: JSON.stringify(route) });
                }
            };
        } else {
            M4PLCommon.CallerNameAndParameters = { "Caller": _addProgram, "Parameters": [s, e, treeView] };
            M4PLCommon.CheckHasChanges.ShowConfirmation();
        }
    };

    var _findCustomerCode = function (selectedNode) {
        var custCode;

        if (selectedNode.parent === null) {
            custCode = selectedNode.GetText();
        } else {
            if (selectedNode.parent.parent === null)
                custCode = selectedNode.parent.GetText();
            else
                custCode = selectedNode.parent.parent.GetText();
        }
        return custCode;
    };

    var _setBreadCrumb = function (currentNode) {
        var breadCrumb = [];
        var customerId;
        var cNode = currentNode.name.split("_");
        if (currentNode.parent == null) {
            customerId = currentNode[1];
            breadCrumb.push({
                text: currentNode.text, programId: 0, customerId: customerId
            });
        } else {
            customerId = findCustomerId(currentNode);
            breadCrumb.push({ text: currentNode.text, programId: currentNode[1], customerId: customerId });
        }

        if (currentNode.parent != null) {
            breadCrumb = recursiveNodes(currentNode.parent, breadCrumb, customerId);
        }

        if (breadCrumb.length > 0) {
            var breadCrumbItems = '<nav id="navBreadCrumb" class="breadcrumb">';

            for (var i = breadCrumb.length - 1; i >= 0; i--) {
                var setActiveClass = "";
                if (i == 0) {
                    setActiveClass = "active";
                }
                breadCrumbItems += '<a data-programId=' + breadCrumb[i].programId + '  data-customerId=' + breadCrumb[i].customerId + ' class="breadcrumb-item breadCrumbClick ' + setActiveClass + '" href="#">' + breadCrumb[i].text + '</a>';
            }

            $('#divBreadCrumb').empty().append(breadCrumbItems + "</nav>");
        }
    }

    var recursiveNodes = function (node, breadCrumb, customerId) {
        if (node.parent == null) {
            breadCrumb.push({ text: node.text, programId: 0, customerId: customerId });
        } else {
            breadCrumb.push({ text: node.text, programId: node.name.split("_")[1], customerId: customerId });
        }

        if (node.parent != null) {
            recursiveNodes(node.parent, breadCrumb, customerId);
        }

        return breadCrumb;
    }

    var findCustomerId = function (selectedNode) {
        var customerId = 0;

        if (selectedNode.parent === null) {
            customerId = selectedNode.name.split("_")[1];
        } else {
            if (selectedNode.parent.parent === null)
                customerId = selectedNode.parent.name.split("_")[1];
            else
                customerId = selectedNode.parent.parent.name.split("_")[1];
        }

        return customerId;
    }

    var _callbackNodeClick = function (s, e, treeView) {
        if (!M4PLCommon.CheckHasChanges.CheckDataChanges()) {
            var selectedNode = treeView.GetSelectedNode();
            if (selectedNode !== null) {
                var route = {}
                route.ParentRecordId = 0;
                route.OwnerCbPanel = _findCustomerCode(selectedNode);
                route.RecordId = 0;
                route.Filters = {};

                var customerId = 0;
                var nodename = selectedNode.name.split("_");
                route.RecordId = parseFloat(nodename[(nodename.length - 1)]);
                if (parseFloat(nodename[0]) === 0) {
                    route.RecordId = 0;
                }

                if (selectedNode.parent === null) {
                    route.Filters.FieldName = "CustomerId";
                    route.Filters.Value = nodename[nodename.length - 1];
                } else {
                    route.ParentRecordId = nodename[nodename.length - 1];
                }

                if (cplTreeView && !cplTreeView.InCallback()) {
                    e.processOnServer = true;
                    cplTreeView.PerformCallback({ strRoute: JSON.stringify(route) });
                }
            }
        } else {
            M4PLCommon.CallerNameAndParameters = { "Caller": _callbackNodeClick, "Parameters": [s, e, treeView] };
            M4PLCommon.CheckHasChanges.ShowConfirmation();
        }
    }

    var _programTreeViewInit = function (s, e) {
        _processNodes(s, s.GetRootNode());
        if (s.GetSelectedNode() !== null && s.GetSelectedNode() != undefined) {
            s.NodeClick.FireEvent(s, s.CreateNodeClickEventArgs(true, s.GetSelectedNode(), s.GetSelectedNode().GetHtmlElement(), MouseEvent));
        }
    }

    var _processNodes = function (tree, node) {
        var htmlElement = node.GetHtmlElement();
        var count = node.GetNodeCount();

        if (htmlElement != null) {
            if (parseInt(node.name.split('_')[0]) !== 0 && ASPxClientControl.GetControlCollection().GetByName('popupMenu')) {
                var handler = function (evt) {
                    tree.SetSelectedNode(node);
                    popupMenu.cpClickedNode = node;
                    popupMenu.ShowAtElement(node.GetHtmlElement());
                    ASPxClientUtils.PreventEventAndBubble(evt);
                };
                ASPxClientUtils.AttachEventToElement(htmlElement, "contextmenu", handler);
            }
        }
        for (var i = 0; i < count; i++) {
            var childNode = node.GetNode(i);
            if (parseInt(childNode.name.split('_')[0]) !== 0) {
                _processNodes(tree, node.GetNode(i));
            }

            if (childNode.nodes.length > 0) {
                for (var ci = 0; ci < childNode.nodes.length; ci++) {
                    _processNodes(tree, childNode.nodes[ci]);
                }
            }
        }
    }

    return {
        Init: init,
        NodeClick: _nodeClick,
        AddProgram: _addProgram,
        FindCustomerCode: _findCustomerCode,
        SetBreadCrumb: _setBreadCrumb,
        CallbackNodeClick: _callbackNodeClick,
        ProgramTreeViewInit: _programTreeViewInit
    };
}();

DevExCtrl.CheckBox = function () {
    var params;

    var init = function (p) {
        params = p;
    };

    var _onMenuRibbonCheckedChanged = function (s, e, MnuOptionLevelCtrl, MnuAccessLevelCtrl, MnuClassificationCtrl, strMnuClassificationDropDownViewModel, menuLookupId, RibbonLookupId) {
        strMnuClassificationDropDownViewModel.ParentId = menuLookupId;
        if (s.GetValue())
            strMnuClassificationDropDownViewModel.ParentId = RibbonLookupId;

        MnuClassificationCtrl.PerformCallback({ strDropDownViewModel: JSON.stringify(strMnuClassificationDropDownViewModel) });
        _onMenuRibbonChange(s, MnuOptionLevelCtrl, MnuAccessLevelCtrl);
    }
    var _onMenuRibbonInit = function (s, e, MnuOptionLevelCtrl, MnuAccessLevelCtrl) {
        _onMenuRibbonChange(s, MnuOptionLevelCtrl, MnuAccessLevelCtrl);
    }
    var _onMenuRibbonChange = function (s, MnuOptionLevelCtrl, MnuAccessLevelCtrl) {
        if (s.GetValue()) {
            MnuOptionLevelCtrl.SetVisible(false);
            MnuAccessLevelCtrl.SetVisible(true);
        } else {
            MnuOptionLevelCtrl.SetVisible(true);
            MnuAccessLevelCtrl.SetVisible(false);
        }
    }

    var _onEnableProgramThreshHold = function (s, e, earlCtrl, lateCtrl) {
        if (earlCtrl) {
            earlCtrl.SetValue(null);
            earlCtrl.SetEnabled(!s.GetValue());
        }
        if (lateCtrl) {
            lateCtrl.SetValue(null);
            lateCtrl.SetEnabled(!s.GetValue());
        }
    }

    var _onCancelOrderActionCheckedChanged = function (s, e, currentCancelOrderDatePicker) {
        if (s.GetValue() && ASPxClientControl.GetControlCollection().GetByName(currentCancelOrderDatePicker) && (ASPxClientControl.GetControlCollection().GetByName(currentCancelOrderDatePicker).GetValue() == null)) {
            ASPxClientControl.GetControlCollection().GetByName(currentCancelOrderDatePicker).SetValue(new Date());
        }
    }

    return {
        init: init,
        MenuRibbonCheckedChanged: _onMenuRibbonCheckedChanged,
        MenuRibbonInit: _onMenuRibbonInit,
        EnableProgramThreshHold: _onEnableProgramThreshHold,
        CancelOrderActionCheckedChanged: _onCancelOrderActionCheckedChanged
    }
}();

DevExCtrl.Button = function () {
    var _onGridClosePopup = function (popupControl) {
    }

    var _onGridDeleteYes = function (s, e, gridControl) {
        M4PLWindow.DataView.OnUpdateEditWithDelete(gridControl, e);
        DisplayMessageControl.SetVisible(false);
    }

    var _onGridDeleteMoreInfo = function (popupControl) {
    }

    var _onGetAssociations = function (s, route) {
        var url = "/Common/GetAssociations?strRoute=" + encodeURIComponent(route);
        window.open(url, '_blank');
    }
    var _onDeleteAll = function (s, e, strRoute) {
        $.ajax({
            type: "Post",
            url: "Common/RemoveDeleteInfoRecords?strRoute=" + strRoute,
            success: function (response) {
                var route = JSON.parse(strRoute);
                var cbCtrl = ASPxClientControl.GetControlCollection().GetByName(route.OwnerCbPanel);

                cbCtrl.PerformCallback({ referenceEntity: route.Controller });
            }
        });
    }
    var _onCopyClick = function (s, e, strRoute) {
        var route = JSON.parse(strRoute);
        RecordPopupControl.PerformCallback({ strRoute: JSON.stringify(route) });
    };
    var _onCopyPaste = function (s, e, recordId, sourceTree, destTree) {
        var destinationCheckedNodes = [];
        for (var i = 0; i < destTree.GetNodeCount() ; i++) {
            var programId = 0;
            var parentNode = destTree.GetNode(i);
            if (parentNode.GetChecked()) {
                programId = parseInt(parentNode.name.split('_')[1]);
                destinationCheckedNodes.push(programId);
            }

            if (parentNode.nodes.length > 0) {
                _recursiveDestinationPrograms(parentNode.nodes, destinationCheckedNodes);
            }
        }
        var sourceTreeHasAnyCheckedNode = false;
        var copyPPPModel = {};
        copyPPPModel.RecordId = recordId;
        copyPPPModel.ToPPPIds = destinationCheckedNodes;
        if (sourceTree.GetNodeCount() == 1) //Main Customer
        {
            var customerNode = sourceTree.GetNode(0);
            copyPPPModel.SelectAll = customerNode.GetChecked();
            if (customerNode.nodes.length === 1 && copyPPPModel.SelectAll === false) { // If main customer is checked then avoid further process
                var custProgramNode = customerNode.GetNode(0);
                copyPPPModel.SelectAll = custProgramNode.GetChecked();
                if (copyPPPModel.SelectAll === false) { // if checked parent then avoid further process.
                    if (custProgramNode.nodes.length === 1) // copying only source tree  project
                    {
                        var projectNode = custProgramNode.nodes[0];
                        copyPPPModel.SelectAll = projectNode.GetChecked();
                        if (projectNode.nodes.length === 1)// copying only source tree phase
                        {
                            var phaseNode = projectNode.nodes[0];
                            copyPPPModel.SelectAll = projectNode.GetChecked();
                            if (copyPPPModel.SelectAll === false)
                                _setChildren(copyPPPModel, phaseNode.nodes);
                        }
                        else if (copyPPPModel.SelectAll === false)
                            _setChildren(copyPPPModel, projectNode.nodes);
                    }
                    else
                        _setChildren(copyPPPModel, custProgramNode.nodes);
                }
                if ((copyPPPModel.ConfigurationIds && copyPPPModel.ConfigurationIds.length > 0) || (copyPPPModel.CopyPPPModelSub && copyPPPModel.CopyPPPModelSub.length > 0))
                    sourceTreeHasAnyCheckedNode = true;
            }
            else
                sourceTreeHasAnyCheckedNode = true;
        }
        DevExCtrl.LoadingPanel.Show(GlobalLoadingPanel);
        var hasCheckBoxesChecked = (destinationCheckedNodes.length > 0) && sourceTreeHasAnyCheckedNode === true;
        $.ajax({
            type: "POST",
            url: "Program/Program/CopyPPPModel",
            data: { "copyPPPModel": copyPPPModel, "hasCheckboxesChecked": hasCheckBoxesChecked },
            success: function (response) {
                if (response.isNotValid) {
                    DisplayMessageControl.PerformCallback({ strDisplayMessage: JSON.stringify(response.displayMessage) });
                    DevExCtrl.LoadingPanel.Hide(GlobalLoadingPanel);
                } else {
                    DevExCtrl.LoadingPanel.Hide(GlobalLoadingPanel);
                    DevExCtrl.PopupControl.Close();//Close the Popup
                    //Refresh the Program Tree
                    if (cplTreeViewPanel !== 'undefined') {
                        if (cplTreeViewPanel && !cplTreeViewPanel.InCallback()) {
                            var nodeNames = [];
                            if (ProgramTree !== "undefined") {
                                var node = ProgramTree.GetSelectedNode();
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
                                    cplTreeViewPanel.PerformCallback({ nodes: JSON.stringify(nodeNames), selectedNode: node.name });
                                }
                            }
                        }
                    }
                }
            },
            error: function () {
                DevExCtrl.LoadingPanel.Hide(GlobalLoadingPanel);
            }
        });
    }

    var _recursiveDestinationPrograms = function (nodes, destinationCheckedNodes) {
        for (var i = 0; i < nodes.length; i++) {
            var programId = 0;
            var parentNode = nodes[i];
            if (parentNode.GetChecked()) {
                programId = parseInt(parentNode.name.split('_')[1]);
                destinationCheckedNodes.push(programId);
            }

            if (parentNode.nodes.length > 0) {
                _recursiveDestinationPrograms(parentNode.nodes, destinationCheckedNodes);
            }
        }
    }

    var _setChildren = function (parentCopyPPPModel, childCopyPPPModel) {
        parentCopyPPPModel.ConfigurationIds = [];
        parentCopyPPPModel.CopyPPPModelSub = [];
        for (var childIndex = 0; childIndex < childCopyPPPModel.length; childIndex++) {
            var childNode = childCopyPPPModel[childIndex];

            var childName = childNode.name;
            var childIdOrName = childName.split('_');
            if (childIdOrName.length == 2) // Id or name like 3_2 or Tab4_ProgramRefGateway
            {
                if (childIdOrName[0].slice(0, 3) === "Tab") {
                    if (childNode.GetChecked())
                        parentCopyPPPModel.ConfigurationIds.push(childIdOrName[1]);
                }
                else { // might be projects or phases
                    var nextParentCopyPPPModel = {};
                    nextParentCopyPPPModel.RecordId = childIdOrName[1];
                    nextParentCopyPPPModel.SelectAll = childNode.GetChecked();
                    if (nextParentCopyPPPModel.SelectAll === false)
                        _setChildren(nextParentCopyPPPModel, childNode.nodes);
                    if (childNode.nodes.length > 0 || nextParentCopyPPPModel.SelectAll === true)
                        parentCopyPPPModel.CopyPPPModelSub.push(nextParentCopyPPPModel);
                }
            }
        }
    }

    return {
        OnGridClosePopup: _onGridClosePopup,
        OnGridDeleteYes: _onGridDeleteYes,
        OnGridDeleteMoreInfo: _onGridDeleteMoreInfo,
        GetAssociations: _onGetAssociations,
        DeleteAll: _onDeleteAll,
        CopyPaste: _onCopyPaste,
        CopyClick: _onCopyClick
    };
}();

DevExCtrl.TreeList = function () {
    var _onNodeClick = function (s, e, contentCbPanel, contentCbPanelRoute) {
        var id = $(s.GetRowByNodeKey(e.nodeKey)).find('span').last().attr('id');
        var isJobParentEntity = false, dashCategoryRelationId = 0, isDataView = false;
        if (!M4PLCommon.CheckHasChanges.CheckDataChanges()) {
            var route = JSON.parse(contentCbPanelRoute);
            route.IsJobParentEntityUpdated = false;
            if (contentCbPanel && !contentCbPanel.InCallback()) {
                if (e.nodeKey.indexOf("_") == -1) {
                    route.ParentRecordId = e.nodeKey;
                }
                if ((route.EntityName == 'Job' || route.EntityName == 'Program EDI Header') && e.nodeKey.indexOf("_") >= 0) {
                    route.ParentRecordId = e.nodeKey.split('_')[1];
                    isJobParentEntity = true;
                    route.IsJobParentEntityUpdated = true;
                    IsDataView = route.Action === "DataView" ? true : false
                }
                route.RecordId = M4PLWindow.OrderId == null ? 0 : M4PLWindow.OrderId;
                contentCbPanel.PerformCallback({ strRoute: JSON.stringify(route), gridName: '', filterId: dashCategoryRelationId, isJobParentEntity: isJobParentEntity, isDataView: isDataView, isCallBack: true });
                DevExCtrl.Ribbon.DoCallBack(route);
            }
            else if (contentCbPanel && contentCbPanel.InCallback() && route.EntityName == 'Job') {
                if (e.nodeKey.indexOf("_") >= 0) {
                    route.ParentRecordId = e.nodeKey.split('_')[1];
                    isJobParentEntity = true;
                    route.IsJobParentEntityUpdated = true;
                    IsDataView = route.Action === "DataView" ? true : false
                }

                contentCbPanel.PerformCallback({ strRoute: JSON.stringify(route), gridName: '', filterId: dashCategoryRelationId, isJobParentEntity: isJobParentEntity, isDataView: isDataView });
                DevExCtrl.Ribbon.DoCallBack(route);
            }
        } else {
            M4PLCommon.CallerNameAndParameters = { "Caller": _onNodeClick, "Parameters": [s, e, contentCbPanel, contentCbPanelRoute] };
            M4PLCommon.CheckHasChanges.ShowConfirmation();
        }
    }

    var _onNodeDisable = function (s, e) {
    }
    var _init = function (s, e, contentCbPanel, contentCbPanelRoute) {
        var isJobParentEntity = false, dashCategoryRelationId = 0, isDataView = false;
        if (s.cpIsJobParent) {
            isJobParentEntity = s.cpIsJobParent;
        }
        if (s.cpselectedNode) {
            if (isJobParentEntity)
                s.SetFocusedNodeKey("Customer_" + s.cpselectedNode);
            else
                s.SetFocusedNodeKey(s.cpselectedNode);
        }
        if (contentCbPanelRoute) {
            var route = JSON.parse(contentCbPanelRoute);
            if (route.ParentRecordId && route.EntityName == 'Job' && (route.Action == "DataView" || route.Action == "FormView" && route.ParentRecordId > 0)) {
                if (contentCbPanel && contentCbPanelRoute && !contentCbPanel.InCallback()) {
                    if (route.EntityName == 'Job' && isJobParentEntity) {
                        IsDataView = route.Action === "DataView" ? true : false
                    }
                    contentCbPanel.PerformCallback({ strRoute: JSON.stringify(route), gridName: '', filterId: dashCategoryRelationId, isJobParentEntity: isJobParentEntity, isDataView: isDataView });
                    DevExCtrl.Ribbon.DoCallBack(route);
                }
            }
        }
    }
    return {
        OnNodeClick: _onNodeClick,
        OnNodeDisable: _onNodeDisable,
        Init: _init
    };
}();

DevExCtrl.LoadingPanel = function () {
    var _show = function (control) {
        control.Show();
    }

    var _hide = function (control) {
        control.Hide();
    }

    return {
        Show: _show,
        Hide: _hide,
    };
}();

DevExCtrl.DateEdit = function () {
    var params;
    var flagUp = false;
    var flagDown = false;

    var init = function (p) {
        params = p;
    };

    var _onCustFCDatesChanged = function (s, e, startDateControl, endDateControl, autoShortCodeControl, workDaysControl) {
        if (ASPxClientControl.GetControlCollection().GetByName(startDateControl) && ASPxClientControl.GetControlCollection().GetByName(endDateControl)) {
            var startDate = ASPxClientControl.GetControlCollection().GetByName(startDateControl).GetValue();
            var endDate = ASPxClientControl.GetControlCollection().GetByName(endDateControl).GetValue();
            if (startDate && (startDate != null) && endDate && (endDate != null)) {
                var startDay = new Date(startDate);
                var endDay = new Date(endDate);
                var millisecondsPerDay = 1000 * 60 * 60 * 24;
                var millisBetween = endDay.getTime() - startDay.getTime();
                var days = millisBetween / millisecondsPerDay;
                if (ASPxClientControl.GetControlCollection().GetByName(workDaysControl))
                    ASPxClientControl.GetControlCollection().GetByName(workDaysControl).SetValue(Math.floor(days) + 1);
            }
            if (endDate && (endDate != null)) {
                var d = new Date(endDate);
                var month = d.getMonth() + 1;
                if (month < 10)
                    month = "0" + month;
                if (ASPxClientControl.GetControlCollection().GetByName(autoShortCodeControl))
                    ASPxClientControl.GetControlCollection().GetByName(autoShortCodeControl).SetValue(d.getFullYear() + '-' + month);
            }
        }
    }

    var _onVendFCDatesChanged = function (s, e, startDateControl, endDateControl, autoShortCodeControl, workDaysControl) {
        if (ASPxClientControl.GetControlCollection().GetByName(startDateControl) && ASPxClientControl.GetControlCollection().GetByName(endDateControl)) {
            var startDate = ASPxClientControl.GetControlCollection().GetByName(startDateControl).GetValue();
            var endDate = ASPxClientControl.GetControlCollection().GetByName(endDateControl).GetValue();
            if (startDate && (startDate != null) && endDate && (endDate != null)) {
                var startDay = new Date(startDate);
                var endDay = new Date(endDate);
                var millisecondsPerDay = 1000 * 60 * 60 * 24;
                var millisBetween = endDay.getTime() - startDay.getTime();
                var days = millisBetween / millisecondsPerDay;
                if (ASPxClientControl.GetControlCollection().GetByName(workDaysControl))
                    ASPxClientControl.GetControlCollection().GetByName(workDaysControl).SetValue(Math.floor(days) + 1);
            }
            if (endDate && (endDate != null)) {
                var d = new Date(endDate);
                var month = d.getMonth() + 1;
                if (month < 10)
                    month = "0" + month;
                if (ASPxClientControl.GetControlCollection().GetByName(autoShortCodeControl))
                    ASPxClientControl.GetControlCollection().GetByName(autoShortCodeControl).SetValue(d.getFullYear() + '-' + month);
            }
        }
    }
    var _onCustVendFCDatesChanged = function (s, e, gridCtrl, startDateControl, endDateControl, autoShortCodeControl, workDaysControl, colColumnName) {
        if (gridCtrl.GetColumnByField(startDateControl) != null && gridCtrl.GetColumnByField(endDateControl)) {
            var startDate = gridCtrl.batchEditApi.GetCellValueByKey(gridCtrl.batchEditHelper.editingRecordKey, startDateControl);
            var endDate = gridCtrl.batchEditApi.GetCellValueByKey(gridCtrl.batchEditHelper.editingRecordKey, endDateControl);
            if (startDateControl == colColumnName)
                startDate = s.GetValue();
            else
                endDate = s.GetValue();

            if (endDateControl === s.name)
                endDate = s.GetValue();
            if (startDate && (startDate != null) && endDate && (endDate != null)) {
                var startDay = new Date(startDate);
                var endDay = new Date(endDate);
                var millisecondsPerDay = 1000 * 60 * 60 * 24;
                var millisBetween = endDay.getTime() - startDay.getTime();
                var days = millisBetween / millisecondsPerDay;
                if (gridCtrl.GetColumnByField(workDaysControl) != null) {
                    gridCtrl.SetEditValue(workDaysControl, Math.floor(days) + 1);
                }
            }
            if (endDate && (endDate != null)) {
                var d = new Date(endDate);
                var month = d.getMonth() + 1;
                if (month < 10)
                    month = "0" + month;
                if (gridCtrl.GetColumnByField(autoShortCodeControl) != null)
                    gridCtrl.SetEditValue(autoShortCodeControl, d.getFullYear() + '-' + month);
            }
        }
    }

    var _onDateTimeInit = function (s, e) {
        var timeEdit = s.GetTimeEdit();
        if (timeEdit != null && timeEdit != undefined) {
            if (s.GetValue() == null) {
                s.GetTimeEdit().SetDate(new Date());
            }
            timeEdit.ButtonClick.AddHandler(_onClick);
        }

        ASPxClientUtils.AttachEventToElement(document, "scroll", function (evt) {
            if (ASPx.GetDropDownCollection().IsEventNotFromControlSelf(evt, s))
                s.HideDropDown();
        });
    }

    //var _dateEdit_EditValueChanging = function (s, e) {
    //    console.log(s.GetValue());
    //}
    var ResetFlags = function () {
        flagUp = false;
        flagDown = false;
    }
    var _onLostFocus = function (s, e) {
        ResetFlags();
    }
    var _onClick = function (s, e) {
        //var caretPosition = s.GetCaretPosition();
        var date = s.GetDate();
        if (date == null) {
            date = new Date();
            date = new Date(date.toDateString().replace(/-/g, "/"));
        }
        if (e.buttonIndex == -2) //increment button
        {
            if (date != null) {
                var hours = date.getHours();
                if (hours == 0) {
                    //date.setHours(hours + 1);
                    //if (flagUp)
                    //    s.SetDate(date);
                    //else
                    //    flagUp = true;
                }
                // s.SetCaretPosition(0);
            }
        }
        if (e.buttonIndex == -3) //decrement button
        {
            if (date != null) {
                var hours = date.getHours();
                if (hours == 0) {
                    //date.setHours(hours - 1);
                    //if (flagDown)
                    //    s.SetDate(date);
                    //else
                    //    flagDown = true;
                }
                // s.SetCaretPosition(0);
            }
        }
    }

    var _timeSpanChanges = function (s, e) {
        var result = s.GetValue();
    }

    var _dataDropDown = function (s, e, date) {
        if (s.GetValue() == null) {
            s.GetTimeEdit().SetDate(new Date(date))
        }
    }

    var _onChangeCheckIsPreviousDate = function (s, e) {
        $.ajax({
            type: "GET",
            url: "/Common/CheckDate?date=" + (new Date(s.GetValue()).toDateString()),
            success: function (response) {
                if (!response.IsValid)
                    DisplayMessageControl.PerformCallback({ strDisplayMessage: response.DisplayMessage });
            },
            error: function () {
            }
        });
    }
    var _onCalendarCellClick = function (s, e) {
        var timeDate = new Date(s.GetTimeEdit().date);
        var currentDate = e.date;
        var date = new Date(currentDate.getFullYear(), currentDate.getMonth(), currentDate.getDate(), timeDate.getHours(), timeDate.getMinutes());
        s.SetDate(date);
        s.HideDropDown();
    }
    return {
        init: init,
        OnCustFCDatesChanged: _onCustFCDatesChanged,
        OnVendFCDatesChanged: _onVendFCDatesChanged,
        OnCustVendFCDatesChanged: _onCustVendFCDatesChanged,
        OnDateTimeInit: _onDateTimeInit,
        OnChangeCheckIsPreviousDate: _onChangeCheckIsPreviousDate,
        Data_DropDown: _dataDropDown,
        OnLostFocus: _onLostFocus,
        TimeSpanChanges: _timeSpanChanges,
        OnCalendarCellClick: _onCalendarCellClick
        //DateEdit_EditValueChanging:_dateEdit_EditValueChanging,
    }
}();

DevExCtrl.PopupControl = function () {
    var postion;

    var init = function (p) {
        postion = p;
    };

    var _beginCallBack = function (s, e) {
        s.SetVisible(false);
    }

    var _endCallBack = function (s, e) {
        var route = s.cpRoute;
        if (route && route.EntityName && route.EntityName.length > 5) {
            s.SetHeaderText(route.EntityName);
        }
        if (s.cpImage && s.cpImage.length > 5) {
            s.SetHeaderImageUrl(s.cpImage);
        }
        if (s.cpHeader) {
            $('.recordPopupHeader').html(s.cpHeader);
        }
        if (s.cpSubHeader) {
            $('.recordSubPopupHeader').html(s.cpSubHeader);
        }
        if (s.cpRoute && s.cpRoute.Action === "GetDeleteInfo")
            s.SetSize(1000, 450); //From _deleteMoreSplitter control

        s.UpdatePosition(postion);
        s.SetVisible(true);
    }

    var _displayMessageEndCallBack = function (s, e) {
        if (s.cpDisplayMessage && s.cpDisplayMessage.ScreenTitle && s.cpDisplayMessage.ScreenTitle.length > 3) {
            s.SetHeaderText(s.cpDisplayMessage.ScreenTitle);

            if (s.cpDisplayMessage.Operations && s.cpDisplayMessage.CloseType == '' && s.cpDisplayMessage.Operations.length == 1 && s.cpDisplayMessage.Operations[0].SysRefName === "Ok") {
                s.closeAction = "OuterMouseClick";
                if (s.cpDisplayMessage.Code === "02.09" || s.cpDisplayMessage.Code === "03.01") {
                    s.closeAction = "None";
                }
            }
        }

        s.SetVisible(true);
        if (s.cpDisplayMessage.Operations[0].SysRefName === "Ok") {
            $("#btnOk").focus();
        }
        else if (s.cpDisplayMessage.Operations[0].SysRefName === "Save") {
            $("#btnSave").focus();
        }
    }

    var _shown = function (s, e) {
        if (GlobalLoadingPanel.IsVisible())
            DevExCtrl.LoadingPanel.Hide(GlobalLoadingPanel);

        if (s.GetHeight() >= window.innerHeight)
            s.SetHeight(window.innerHeight - 20);
        else
            s.SetHeight();
        s.SetWidth(s.GetWidth() + 15);
        window.setTimeout(function () {
            if (/*@cc_on!@*/false || !!document.documentMode)
                s.SetWidth(s.GetWidth() + 15);
        }, 50);
    }

    var _displayMessageShown = function (s, e) {
        _shown(s, e);
        if (s.cpDisplayMessage != null && s.cpDisplayMessage.CloseType == '' && s.cpDisplayMessage.Operations != null
            && s.cpDisplayMessage.Operations.length > 1 && s.cpDisplayMessage.Operations[0].SysRefName === "Ok") {
            s.closeAction = "OuterMouseClick";
        }
    }

    var _closing = function (s, e) {
        s.SetContentHtml('');
        s.SetSize(0, 0);
        postion = s.GetPosition();
    }

    var _resize = function (s, e) {
    }

    var _close = function () {
        if (!M4PLCommon.CheckHasChanges.CheckDataChanges()) {
            if (ASPxClientControl.GetControlCollection().GetByName('RecordSubPopupControl') && ASPxClientControl.GetControlCollection().GetByName('RecordSubPopupControl').IsVisible()) {
                ASPxClientControl.GetControlCollection().GetByName('RecordSubPopupControl').Hide();
            } else {
                RecordPopupControl.Hide();
                M4PLCommon.IsIgnoreClick = false;
            }
        }

        else if (RecordPopupControl.cpRoute.Entity == "JobXcblInfo" || RecordPopupControl.cpRoute.Entity == "JobGateway") {

            var currentGrid = ASPxClientControl.GetControlCollection().GetByName("JobGatewayGridView");
            if (currentGrid) {
                var listOfElements = document.getElementsByClassName("dxgvBatchEditModifiedCell_Office2010Black");
                var nextElement = $('#' + listOfElements[listOfElements.length - 1].closest('tr').id).next('tr').attr('id').match(/\d+$/);
                if (nextElement == null) {
                    var currentElementIndex = listOfElements[listOfElements.length - 1].closest('tr').id.match(/\d+$/)[0];
                }
                else {
                    var currentElementIndex = nextElement[0] - 1;
                }
                currentGrid.CancelEdit(currentElementIndex);
                ASPxClientControl.GetControlCollection().GetByName("btnSaveJobGatewayGridView").SetEnabled(false);
                ASPxClientControl.GetControlCollection().GetByName("btnCancelJobGatewayGridView").SetEnabled(false);
                $("#btnSaveJobGatewayGridView").addClass("noHover");
                $("#btnCancelJobGatewayGridView").addClass("noHover");
                M4PLWindow.PopupDataViewHasChanges[currentGrid] = false;
                M4PLWindow.DataViewsHaveChanges[currentGrid] = false;
            }

            RecordPopupControl.Hide();
            M4PLCommon.IsIgnoreClick = false;
        }

        else {
            M4PLCommon.CallerNameAndParameters = { "Caller": _close, "Parameters": [] };
            M4PLCommon.CheckHasChanges.ShowConfirmation();
        }
    }

    var _appendErrorMessages = function (errorMessages) {
        var divNameToTake = '.recordPopupErrorMessages';
        if (ASPxClientControl.GetControlCollection().GetByName('RecordSubPopupControl') && ASPxClientControl.GetControlCollection().GetByName('RecordSubPopupControl').IsVisible())
            divNameToTake = '.recordSubPopupErrorMessages';
        for (var i = 0; i < errorMessages.length; i++)
            $(divNameToTake).append('<p>* ' + errorMessages[i] + '</p>');
    }

    var _mapVendorClose = function (cbPanel) {
        if (ASPxClientControl.GetControlCollection().GetByName(cbPanel) && ASPxClientControl.GetControlCollection().GetByName(cbPanel).IsVisible()) {
            DevExCtrl.LoadingPanel.Show(GlobalLoadingPanel)
            ASPxClientControl.GetControlCollection().GetByName(cbPanel).PerformCallback();
        }
        _close();
        DevExCtrl.LoadingPanel.Hide(GlobalLoadingPanel)
    }

    var _onGetDeleteInfoModules = function (strRoute) {
        var route = JSON.parse(strRoute);
        route.OwnerCbPanel = route.Action + "DataAppCBPanel";
        if (RecordPopupControl.IsVisible()) {
            RecordSubPopupControl.PerformCallback({ strRoute: JSON.stringify(route), strByteArray: "" });
        } else {
            RecordPopupControl.PerformCallback({ strRoute: JSON.stringify(route), strByteArray: "" });
        }
    }

    var _onProgramCopyClose = function (cbPanel) {
        _close();
    };

    return {
        init: init,
        BeginCallBack: _beginCallBack,
        EndCallBack: _endCallBack,
        Shown: _shown,
        Closing: _closing,
        Resize: _resize,
        DisplayMessageEndCallBack: _displayMessageEndCallBack,
        AppendErrorMessages: _appendErrorMessages,
        Close: _close,
        MapVendorClose: _mapVendorClose,
        DisplayMessageShown: _displayMessageShown,
        GetDeleteInfoModules: _onGetDeleteInfoModules,
        ProgramCopyClose: _onProgramCopyClose,
    }
}();

DevExCtrl.BinaryImage = function () {
    var _error = function (s, e) {
    }

    var _validation = function (s, e) {
    }

    var _valueChanged = function (s, e) {
    }

    var _init = function (s, e) {
    }

    return {
        Error: _error,
        Validation: _validation,
        ValueChanged: _valueChanged,
        Init: _init,
    }
}();

DevExCtrl.Dashboard = function () {
    var _onDashboardEndUpdate = function (s, e) {
    }

    var _onBeforeRender = function (s, e) {
        var control = s.getDashboardControl();
    }

    return {
        OnDashboardEndUpdate: _onDashboardEndUpdate,
        OnBeforeRender: _onBeforeRender,
    }
}();

DevExCtrl.Radio = function () {
    var _onDataViewMenuRibbonCheckedChanged = function (s, destCtrl, gridCtrl) {
        destCtrl.SetValue(!s.GetValue());

        //s.SetValue(null);

        //if (s.name === rbnCtrl.name) {
        //    destCtrl.SetValue(!s.GetValue());

        //    //grid.GetEditor(MnuCtrl).SetValue(!s.GetValue());

        //    //MnuCtrl.SetValue(!s.GetValue())

        //    //grid.batchEditApi.SetCellValue(e.visibleIndex, MnuCtrl.name, !s.GetValue());

        //} else {
        //    //rbnCtrl.SetValue(!s.GetValue());
        //   // grid.GetEditor(rbnCtrl).SetValue(!s.GetValue());
        //    destCtrl.SetValue(!s.GetValue());
        //    //grid.batchEditApi.SetCellValue(e.visibleIndex, rbnCtrl.name, !s.GetValue());
        //}
    }
    var _onMenuDriverRibbonLostFocus = function MenuDriverRibbonLostFocus(gridCtrl) {
        //if (!preventEndEditOnLostFocus)
        gridCtrl.batchEditApi.EndEdit();
        //preventEndEditOnLostFocus = false;
    }

    var _onEdiHeaderRadioLostFocus = function EdiHeaderRadioLostFocus(gridCtrl) {
        //if (!preventEndEditOnLostFocus)
        gridCtrl.batchEditApi.EndEdit();
        //preventEndEditOnLostFocus = false;
    }

    return {
        DataViewMenuRibbonCheckedChanged: _onDataViewMenuRibbonCheckedChanged,
        MenuDriverRibbonLostFocus: _onMenuDriverRibbonLostFocus,
        EdiHeaderRadioLostFocus: _onEdiHeaderRadioLostFocus
    }
}();

DevExCtrl.Menu = function () {
    var _onUserMenuClick = function (s, e) {
        if (e.item.name !== null && e.item.name.trim() != '') {
            var route = JSON.parse(e.item.name);

            if (route.Action === "Logout") {
                $.ajax({
                    type: "GET",
                    url: route.Url,
                    success: function (response) {
                        window.location.href = "/Account/Index";
                        window.history.go(0);
                    }
                });
            } else {
                window.location.href = route.Url;
            }
        }
    };

    return {
        UserMenuClick: _onUserMenuClick
    }
}();

DevExCtrl.EdiHeader = function () {
    var _onCreateEdiHeaderFromRibbon = function (s, e, route) {
        route.Action = "FormView";
        _doEdiHeaderCallback(route);
    }

    var _onFormViewEdiHeaderFromRibbon = function (s, e, route) {
        route.Action = "FormView";
        _doEdiHeaderCallback(route);
    }
    var _doEdiHeaderCallback = function (route) {
        if (!$.isNumeric(TreeList.GetFocusedNodeKey())) {
            return;
        }
        try {
            route.OwnerCbPanel = "PrgEdiHeaderDataViewCbPanel"
            route.ParentRecordId = parseInt(TreeList.GetFocusedNodeKey());
            route.ParentEntity = "Program";

            if (PrgEdiHeaderDataViewCbPanel && !PrgEdiHeaderDataViewCbPanel.InCallback()) {
                PrgEdiHeaderDataViewCbPanel.PerformCallback({ strRoute: JSON.stringify(route) });
                DevExCtrl.Ribbon.DoCallBack(route);
            }
        }
        catch (err) {
        }
    }

    var _onDataViewEdiHeaderFromRibbon = function (s, e, route) {
        route.Action = "DataView";
        _doEdiHeaderCallback(route);
    }

    return {
        CreateEdiHeaderFromRibbon: _onCreateEdiHeaderFromRibbon,
        FormViewEdiHeaderFromRibbon: _onFormViewEdiHeaderFromRibbon,
        DataViewEdiHeaderFromRibbon: _onDataViewEdiHeaderFromRibbon
    }
}();

DevExCtrl.Decimal = function () {
    var _onCalculateCubes = function (s, e, cubesCtrl, Ctrl1, Ctrl2) {
        if (cubesCtrl) {
            cubesCtrl.SetValue(s.GetValue() * Ctrl1.GetValue() * Ctrl2.GetValue());
        }
    }

    var _onQuantityChanged = function (s, e, qtyExpectedCtrl, qtyOnHandCtrl, qtyOnHoldCtrl, qtyDamagedCtrl, qtyStartOverCtrl) {
        if (qtyExpectedCtrl && qtyOnHandCtrl && qtyOnHoldCtrl && qtyDamagedCtrl && qtyStartOverCtrl)
            qtyStartOverCtrl.SetValue(qtyExpectedCtrl.GetValue() - (qtyOnHandCtrl.GetValue() + qtyOnHoldCtrl.GetValue() + qtyDamagedCtrl.GetValue()));
    }

    return {
        CalculateCubes: _onCalculateCubes,
        QuantityChanged: _onQuantityChanged
    }
}();

DevExCtrl.PageControl = function () {
    var _onManualTabClick = function (currentPageControl, index) {
        $('#' + currentPageControl + '_T' + index).trigger('click');
    }

    var _onTabClick = function (s, e) {
        var currentActiveTabIndex = s.GetActiveTabIndex();
        if ((currentActiveTabIndex != e.tab.index) && ($('#pageControl_C' + currentActiveTabIndex).find('div[id^="btnSave"][id$="GridView"]').length > 0)) {
            var allGrids = $('#pageControl_C' + currentActiveTabIndex).find('div[id^="btnSave"]').not('[id*="_CD"]');
            var firstGridName = $(allGrids[0]).attr('id').replace('btnSave', '');
            var secondGridName = null;
            if (allGrids.length > 1)
                secondGridName = $(allGrids[1]).attr('id').replace('btnSave', '');
            var hasFirstGridChanged = M4PLCommon.CheckHasChanges.CheckDataChanges(firstGridName);
            var hasSecondGridChanged = false;
            if (secondGridName != null)
                hasSecondGridChanged = M4PLCommon.CheckHasChanges.CheckDataChanges(secondGridName);
            if (hasFirstGridChanged || hasSecondGridChanged) {
                e.cancel = true;
                M4PLCommon.CallerNameAndParameters = { "Caller": _onManualTabClick, "Parameters": [s.name, e.tab.index] };
                M4PLCommon.CheckHasChanges.ShowConfirmation();
            }
        }
    }

    var _onActiveTabChanging = function (s, e, isNotFromInnerPageControl) {
        if (!isNotFromInnerPageControl) {
            var callbackRoute = JSON.parse(M4PLCommon.Common.GetParameterValueFromRoute('strRoute', e.tab.tabControl.callbackUrl));
            if (callbackRoute != null && callbackRoute.Action === "TabViewCallBack" && callbackRoute.Controller === "Job") {
                if (e.tab.index == 4 || e.tab.index == 5) {
                    e.reloadContentOnCallback = true;
                }
            }
            else if (callbackRoute != null && callbackRoute.Action === "TabView" && (callbackRoute.Controller === "JobDocReference" || callbackRoute.Controller === "JobGateway")) {
                e.reloadContentOnCallback = true;
            }
            else if (callbackRoute != null && callbackRoute.Action === "TabViewCallBack" && callbackRoute.Controller === "Program") {
                if (e.tab.index == 3 || e.tab.index == 5) {
                    e.reloadContentOnCallback = true;
                }
            }
        } else {
            /*For Confirmation On Tab Changing */
        }
    }

    var _onActiveTabChanged = function (s, e, parentEntity, urlToCall) {
        $.ajax({
            type: "GET",
            url: urlToCall + "?currentEntity=" + parentEntity + "&currentTabIndex=" + s.activeTabIndex
        });
    }

    return {
        TabClick: _onTabClick,
        ActiveTabChanging: _onActiveTabChanging,
        ActiveTabChanged: _onActiveTabChanged,
    }
}();

DevExCtrl.ListBox = function () {
    var onInit = function (currentListBox) {
        if (currentListBox && currentListBox.itemsValue && (lblEmployees.itemsValue.length > 0)) {
            currentListBox.SetSelectedIndex(0);
            GetDeleteInfoDataAppCbPanel.PerformCallback({ referenceEntity: lblEmployees.itemsValue[0] });
        }
    };

    var _onListBoxValueChanged = function (s, e) {
        DevExCtrl.LoadingPanel.Show(GlobalLoadingPanel)
        GetDeleteInfoDataAppCbPanel.PerformCallback({ referenceEntity: s.GetValue() });
    }

    return {
        OnInit: onInit,
        OnListBoxValueChanged: _onListBoxValueChanged
    }
}();

DevExCtrl.PopupMenu = function () {
    var _onItemClick = function (s, e) {
        var route = JSON.parse(e.item.name);
        route.RecordId = ProgramTree.GetSelectedNode().name.split('_')[1];

        RecordPopupControl.PerformCallback({ strRoute: JSON.stringify(route) });
    };

    var _onPopUp = function (s, e) {
    };

    return {
        ItemClick: _onItemClick,
        PopUp: _onPopUp
    }
}();

DevExCtrl.ReportDesigner = function () {
    var _onExit = function (s, e, currentRoute) {
        if (!M4PLCommon.CheckHasChanges.CheckDataChanges())
            AppCbPanel.PerformCallback({ strRoute: currentRoute });
        else {
            M4PLCommon.CallerNameAndParameters = { "Caller": _onExit, "Parameters": [s, e, currentRoute] };
            M4PLCommon.CheckHasChanges.ShowConfirmation();
        }
    }
    var _initViewer = function (s, e) {
        var xportContol = s.toolbar.GetItemTemplateControl("SaveFormat");
        xportContol.SetSelectedIndex(1);
        for (var i = xportContol.GetItemCount() - 1; i > 0; i--) {
            var item = xportContol.GetItem(i);
            if (item.text != "XLS" && item.text != "XLSX") {
                xportContol.RemoveItem(i);
            }
        }
        for (var i = 0; i < xportContol.GetItemCount() ; i++) {
            var item = xportContol.GetItem(i);
            if (item.text != "XLS" && item.text != "XLSX") {
                xportContol.RemoveItem(i);
            }
        }
    }

    var _endCallback = function (s, e) {

        $("#VOCReport_Splitter_Viewer_ContentFrame")[0].contentWindow.document.body.onclick =
            function () {
                if (ASPxClientControl.GetControlCollection().GetByName("CustomerLocationCbPanelClosed")) {
                    ASPxClientControl.GetControlCollection().GetByName("CustomerLocationCbPanelClosed").HideDropDown();
                }
            }
    }
    var _customizeActions = function (s, e) {
        //add custom action
        e.Actions.push({
            text: "Show report help",
            imageClassName: "dxrd-custom-export-image",
            disabled: ko.observable(false),
            visible: true,
            clickAction: function () {
                popReportHelp.Show()
            }
        });
    }
    return {
        OnExit: _onExit,
        InitViewer: _initViewer,
        EndCallback: _endCallback,
        CustomizeActions: _customizeActions
    }
}();

DevExCtrl.TokenBox = function () {
    var _valueChanged = function (s, e, CallbackPanelAnalystResponsibleDriver) {
        var tokenCollection = s.GetTokenCollection();

        if (tokenCollection.length > 0) {
            for (var i = 0; i < tokenCollection.length - 1; i++) {
                var it = s.FindItemByText(tokenCollection[i]);
                if (it !== null)
                    s.RemoveTokenByText(it.text);
            }
        }

        CallbackPanelAnalystResponsibleDriver.PerformCallback();

        var index = s.GetTokenIndexByText(JobSiteCode.GetValue());

        if (ASPxClientControl.GetControlCollection().GetByName("JobJobGatewayTabView2GatewaysCbPanel")) {
            var index = s.GetTokenIndexByText(JobSiteCode.GetValue());
            var strRoute = M4PLCommon.Common.GetParameterValueFromRoute('strRoute', JobJobGatewayTabView2GatewaysCbPanel.callbackUrl);
            var route = JSON.parse(strRoute);
            route.Filters = {};
            route.Filters.FieldName = JobSiteCode.GetValue();
            if (index < 0)
                route.Filters.FieldName = null;
            JobJobGatewayTabView2GatewaysCbPanel.callbackCustomArgs["strRoute"] = JSON.stringify(route);
            JobJobGatewayTabView2GatewaysCbPanel.PerformCallback({ strRoute: JSON.stringify(route) });
        }
    }

    var _init = function (s, e, CallbackPanelAnalystResponsibleDriver) {
        var tokenCollection = s.GetTokenCollection();
        var index = s.GetTokenIndexByText(JobSiteCode.GetValue());
        if (tokenCollection.length > 0) {
            CallbackPanelAnalystResponsibleDriver.PerformCallback();
            if (ASPxClientControl.GetControlCollection().GetByName("JobJobGatewayTabView2GatewaysCbPanel")) {
                var strRoute = M4PLCommon.Common.GetParameterValueFromRoute('strRoute', JobJobGatewayTabView2GatewaysCbPanel.callbackUrl);
                var route = JSON.parse(strRoute);
                route.Filters = {};
                route.Filters.FieldName = JobSiteCode.GetValue();
                if (index < 0)
                    route.Filters.FieldName = null;
                JobJobGatewayTabView2GatewaysCbPanel.callbackCustomArgs["strRoute"] = JSON.stringify(route);
                JobJobGatewayTabView2GatewaysCbPanel.PerformCallback({ strRoute: JSON.stringify(route) });
            }
        }
    }
    return {
        ValueChanged: _valueChanged,
        Init: _init
    }
}();