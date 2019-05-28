/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
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
        ItemClick: _itemClick,
    };
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

        if ((route.Action === "Copy") && route.RecordId && (route.RecordId > 0)) {
            var dummy = document.createElement("input");
            document.body.appendChild(dummy);
            var selectedText = M4PLCommon.Control.GetSelectedText();
            dummy.setAttribute('value', selectedText);
            dummy.select();
            document.execCommand("copy");
            localStorage.setItem("CopiedText", selectedText);
            document.body.removeChild(dummy);
            return;
        }

        if ((route.Action === "Paste") && route.RecordId && (route.RecordId > 0) && M4PLCommon.FocusedControlName) {
            M4PLCommon.Control.UpdateSelectedText();
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
                case "DataView":
                case "Dashboard":

                    if (AppCbPanel && !AppCbPanel.InCallback()) {
                        route.OwnerCbPanel = appCbPanelName;
                        AppCbPanel.PerformCallback({ strRoute: JSON.stringify(route) });
                    }
                    _doCallBack(route);
                    break;
                case "ChooseColumns":
                    route.OwnerCbPanel = appCbPanelName; //This OwnerCbPanel assigning for Choose Column Functionality so that can do callback of given cbpanel.

                    RecordPopupControl.PerformCallback({ strRoute: JSON.stringify(route) });
                    break;
                case "ExportExcel":
                case "ExportPdf":
                    window.location = route.Url + "?strRoute=" + JSON.stringify(route);
                    break;
                default:
                    if (route.Action === "Create" && (route.Controller === "OrgRefRole")) {
                        switch (route.Action) {
                            case "Create":
                                route.RecordId = 0;
                                break;
                        }
                    }
                    _onFilterClicked(s, e, route, '');
                    break;
            }

        } else {

            M4PLCommon.CallerNameAndParameters = { "Caller": _onCommandExecuted, "Parameters": [s, e, gridNameSuffix, appCbPanelName] };
            M4PLCommon.CheckHasChanges.ShowConfirmation();

        }
    }

    var _doCallBack = function (route) {
        // M4PLRibbon.SetVisible((route.Action != "Dashboard"));
        if (RibbonCbPanel && !RibbonCbPanel.InCallback()) {
            route.OwnerCbPanel = "RibbonCbPanel";
            RibbonCbPanel.PerformCallback({ strRoute: JSON.stringify(route) });
        }
    }

    var _onFilterClicked = function (s, e, route, ownerCbPanel) {
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
                                        var currentGrid = ASPxClientControl.GetControlCollection().GetByName(response.route.EntityName + gridNameSuffix);
                                        //currentGrid.SetFilterEnabled(true);
                                        currentGrid.ShowFilterControl();
                                        break;
                                    case "ToggleFilter":
                                        if (response.route.Controller === "Job") {
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

    return {
        init: init,
        OnCommandExecuted: _onCommandExecuted,
        OnFilterClicked: _onFilterClicked,
        DoCallBack: _doCallBack,
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

    var _onInitProgramRoleCode = function (s, e, prgRoleCodeCtrl, codeValue) {

        if (prgRoleCodeCtrl && codeValue.trim().length > 0)
            prgRoleCodeCtrl.SetText(codeValue);
    };

    var _onCustomHighlighting = function (s, e) {
        e.highlighting = new RegExp(e.filter.toLowerCase(), "gi");
    }

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
        OnCustomHighlighting: _onCustomHighlighting
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

                var customerCode = _findCustomerCode(e.node.parent);

                if (cplTreeView && !cplTreeView.InCallback()) {
                    e.processOnServer = true;
                    cplTreeView.PerformCallback({ strRoute: JSON.stringify(route) });
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

        for (var i = 0; i < nodes.length ; i++) {
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

        if (!M4PLCommon.CheckHasChanges.CheckDataChanges()) {
            if (contentCbPanel && !contentCbPanel.InCallback()) {
                var route = JSON.parse(contentCbPanelRoute);
                // For customer Nodes, Node name given as Customer_Id , only because of keyvalue is duplicate may occur like custId and programId as same
                // For Tree List it was only id
                // returns -1 if "_" not found in Key
                if (e.nodeKey.indexOf("_") == -1) {
                    route.ParentRecordId = e.nodeKey;
                    contentCbPanel.PerformCallback({ strRoute: JSON.stringify(route) });
                    DevExCtrl.Ribbon.DoCallBack(route);
                }
            }
        } else {
            M4PLCommon.CallerNameAndParameters = { "Caller": _onNodeClick, "Parameters": [s, e, contentCbPanel, contentCbPanelRoute] };
            M4PLCommon.CheckHasChanges.ShowConfirmation();
        }
    }

    var _onNodeDisable = function (s, e) {

    }

    return {
        OnNodeClick: _onNodeClick,
        OnNodeDisable: _onNodeDisable
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
        ASPxClientUtils.AttachEventToElement(document, "scroll", function (evt) {
            if (ASPx.GetDropDownCollection().IsEventNotFromControlSelf(evt, s))
                s.HideDropDown();
        });
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

    return {
        init: init,
        OnCustFCDatesChanged: _onCustFCDatesChanged,
        OnVendFCDatesChanged: _onVendFCDatesChanged,
        OnCustVendFCDatesChanged: _onCustVendFCDatesChanged,
        OnDateTimeInit: _onDateTimeInit,
        OnChangeCheckIsPreviousDate: _onChangeCheckIsPreviousDate
    }
}();

DevExCtrl.PopupControl = function () {
    var postion;

    var init = function (p) {
        postion = p;
    };

    var _beginCallBack = function (s, e) {
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
            }
        } else {
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
        if (ASPxClientControl.GetControlCollection().GetByName(cbPanel) && ASPxClientControl.GetControlCollection().GetByName(cbPanel).IsVisible())
            ASPxClientControl.GetControlCollection().GetByName(cbPanel).PerformCallback();

        _close();
    }

    var _onGetDeleteInfoModules = function (strRoute) {

        var route = JSON.parse(strRoute);
        route.OwnerCbPanel = route.Action + "DataAppCBPanel";
        if (RecordPopupControl.IsVisible()) {
            RecordSubPopupControl.PerformCallback({ strRoute: JSON.stringify(route), strByteArray: "" });
            window.setTimeout(function () {
                RecordSubPopupControl.UpdatePosition();
            }, 50);
        } else {
            RecordPopupControl.PerformCallback({ strRoute: JSON.stringify(route), strByteArray: "" });
            window.setTimeout(function () {
                RecordPopupControl.UpdatePosition();
            }, 50);
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

    return {
        OnDashboardEndUpdate: _onDashboardEndUpdate,
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
            if (callbackRoute != null && callbackRoute.Action === "DeliveryTabView" && callbackRoute.Controller === "Job") {
                if (e.tab.index == 5) {
                    e.reloadContentOnCallback = true;
                }
            } else {
                e.reloadContentOnCallback = true;
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

    return {
        OnExit: _onExit
    }
}();