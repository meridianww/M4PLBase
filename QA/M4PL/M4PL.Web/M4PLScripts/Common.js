﻿/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Kirty Anurag
//Date Programmed:                              10/10/2017
//Program Name:                                 Commom.js
//Purpose:                                      For implementing common client side logic throughout the application
//====================================================================================================================================================*/

$(document).ready(function () {
    $(document).keypress(function (e) {
        if (e.keyCode == 13)
            M4PLCommon.DisplayMessage.DefaultClientOk();
    });
});

$(function () {
    M4PLCommon.ContactCombobox.init();
    M4PLCommon.CompanyCombobox.init();
    M4PLCommon.Common.init();
});

var M4PLCommon = M4PLCommon || {};
M4PLCommon.CurrentByteArrayCount = 0;
M4PLCommon.CopiedText = null;
M4PLCommon.FocusedControlName = null;
M4PLCommon.FormDataChanged = false;
M4PLCommon.IsFromSubDataViewSaveClick = false;
M4PLCommon.CallerNameAndParameters = { "Caller": null, "Parameters": [] };
M4PLCommon.IsFromSubTabCancelClick = false;
M4PLCommon.IsIgnoreClick = false;
M4PLCommon.IsIgnoreCardGridClick = false;

M4PLCommon.Common = function () {
    var params;
    var init = function (p) {
        params = p;
    };

    var _onCallbackError = function (s, e) {
        e.handled = true;
        var errorMessageFromServer = e.message;
    }
    var _getLookupIdByName = function (s, lookupName) {
        $.ajax({
            type: "GET",
            url: "/Common/GetLookupIdByName?lookupName=" + lookupName,
            success: function (response) {
                if (response && response.status && response.status === true && response.lookupId && response.lookupId > 0) {
                    return response.lookupId;
                }
            }
        });
    }

    var _routeParameterValue = function (name, url) {
        if (!url) url = window.location.href;
        name = name.replace(/[\[\]]/g, "\\$&");
        var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
            results = regex.exec(url);
        if (!results) return null;
        if (!results[2]) return '';
        return decodeURIComponent(results[2].replace(/\+/g, " "));
    }

    var _onLogOut = function () {
        $.ajax({
            type: "GET",
            url: "/Account/LogOut",
            success: function (response) {
                window.location.href = "/Account/Index";
                window.history.go(0);
            }
        });
    }

    var _switchOrganization = function (orgId, lastRoute) {
        $.ajax({
            type: "GET",
            url: "/Account/SwitchOrganization/?orgId=" + orgId + "&strRoute=" + lastRoute,
            success: function (response) {
                if (response.status && response.status === true) {
                    DisplayMessageControl.Hide();
                    window.location.reload();
                }
            }
        });
    }

    var _reloadApplication = function () {
        window.location.reload();
    }

    var _onThemeChange = function (s, e, themeUrl) {
        if (!M4PLCommon.CheckHasChanges.CheckDataChanges()) {
            $.ajax({
                url: themeUrl,
                type: "GET",
                dataType: "json",
                data: {
                    'theme': s.GetValue()
                },
                traditional: true,
                contentType: "application/json; charset=utf-8",
                success: function (res) {
                    if (res) {
                        _reloadApplication();
                    }
                }
            });
        } else {
            M4PLCommon.CallerNameAndParameters = { "Caller": _onThemeChange, "Parameters": [s, e, themeUrl] };
            M4PLCommon.CheckHasChanges.ShowConfirmation();
        }
    }

    var _hideGlobalLoadingPanel = function (s, e) {
        DevExCtrl.LoadingPanel.Hide(GlobalLoadingPanel);
    }

    var _browserIndexClosed = function (s, e) {
        window.close();
    }

    var _arrayRemove = function (arr, value) { return arr.filter(function (ele) { return ele != value; }); }

    var _enableJobGridMultiSelection = function (isEnable) {
        var isJobGrid = true;
        var sJobGrid = ASPxClientControl.GetControlCollection().GetByName("JobGridView");
        if (sJobGrid == null || sJobGrid == undefined) {
            sJobGrid = ASPxClientControl.GetControlCollection().GetByName("JobCardGridView");
            if (sJobGrid != null && sJobGrid != undefined)
                isJobGrid = false;
        }
        if (sJobGrid != null && sJobGrid != undefined) {
            var clearBtnCtrl = ASPxClientControl.GetControlCollection().GetByName("btnClearSelectionJobGridView");
            if (clearBtnCtrl == null || clearBtnCtrl == undefined)
                clearBtnCtrl = ASPxClientControl.GetControlCollection().GetByName("btnClearSelectionJobCardGridView");
            if (clearBtnCtrl != null && clearBtnCtrl != undefined) {
                if (!isEnable) {
                    clearBtnCtrl.SetEnabled(false);
                    if (isJobGrid)
                        $("#btnClearSelectionJobGridView").addClass("noHover");
                    else
                        $("#btnClearSelectionJobCardGridView").addClass("noHover");
                }
                else {
                    clearBtnCtrl.SetEnabled(true);
                    if (isJobGrid)
                        $("#btnClearSelectionJobGridView").removeClass("noHover");
                    else
                        $("#btnClearSelectionJobCardGridView").removeClass("noHover");
                }
            }
        }
    }

    var _programImportComboBox = function (s, e, strRoute) {
        var route = JSON.parse(strRoute);
        route.Location = [];
        route.Location.push(s.GetValue());
        if (s.GetValue() != null && s.GetValue() != undefined && s.GetValue() != "") {
            var ctrl = ASPxClientControl.GetControlCollection().GetByName("RecordPopupControl");
            if (ctrl != null)
                ctrl.PerformCallback({ strRoute: JSON.stringify(route) });
        } else {
            s.dropDownButtonIndex = -1;
        }
    }

    return {
        init: init,
        SwitchOrganization: _switchOrganization,
        GetLookupIdByName: _getLookupIdByName,
        OnCallbackError: _onCallbackError,
        OnThemeChange: _onThemeChange,
        GetParameterValueFromRoute: _routeParameterValue,
        ReloadApplication: _reloadApplication,
        LogOut: _onLogOut,
        HideGlobalLoadingPanel: _hideGlobalLoadingPanel,
        BrowserIndexClosed: _browserIndexClosed,
        ArrayRemove: _arrayRemove,
        EnableJobGridMultiSelection: _enableJobGridMultiSelection,
        ProgramImportComboBox: _programImportComboBox
    };
}();

M4PLCommon.RichEdit = function () {
    var _openDialog = function (route, byteArray) {
        if (byteArray.IsPopup === true)
            RecordSubPopupControl.PerformCallback({ strRoute: JSON.stringify(route), strByteArray: JSON.stringify(byteArray) });
        else
            RecordPopupControl.PerformCallback({ strRoute: JSON.stringify(route), strByteArray: JSON.stringify(byteArray) });
    }

    var _openDialogOpenClick = function (s, e) {
        RichEditFileUpload.Upload();
    }
    var _openDialogCancelClick = function (s, e, isPopup) {
        if (isPopup === true)
            RecordSubPopupControl.SetVisible(false);
        else
            RecordPopupControl.SetVisible(false);
    }

    var _openDialogUploadComplete = function (s, e, byteArray, richEditControl) {
        if (richEditControl && !richEditControl.InCallback())
            richEditControl.PerformCallback({ strByteArray: JSON.stringify(byteArray) });
        _openDialogCancelClick(s, e, byteArray.IsPopup);
    }

    var _richEditorsPerformCallBack = function (route, byteArray, gatewayIds) {

        $.each(byteArray, function (index, value) {
            if (ASPxClientControl.GetControlCollection().GetByName(value.ControlName)) {
                M4PLCommon.CurrentByteArrayCount += 1;
                ASPxClientControl.GetControlCollection().GetByName(value.ControlName).callbackCustomArgs["ByteArrayRecordId"] = route.RecordId;//same callbackCustomArgs name as WebApplicationConstants.ByteArrayRecordId
                value.JobGatewayIds = gatewayIds;
                ASPxClientControl.GetControlCollection().GetByName(value.ControlName).PerformCallback({ strByteArray: JSON.stringify(value) });
            }
        });
    }

    var _onEndCallBack = function (s, e) {
        M4PLCommon.CurrentByteArrayCount -= 1;
        M4PLCommon.Error.CheckServerError();
    }

    return {
        OpenDialog: _openDialog,
        OpenDialogOpenClick: _openDialogOpenClick,
        OpenDialogCancelClick: _openDialogCancelClick,
        OpenDialogUploadComplete: _openDialogUploadComplete,
        RichEditorsPerformCallBack: _richEditorsPerformCallBack,
        OnEndCallBack: _onEndCallBack,
    };
}();

M4PLCommon.ContactCombobox = function () {
    var params;

    var init = function (p) {
        params = p;
    };

    var _onValueChanged = function (s, e, ownerCbPanel, dropDownViewModel, controlSuffix) {
        var controlName = dropDownViewModel.IsPopup === true ? dropDownViewModel.ControlName + "_popup" : dropDownViewModel.ControlName;
        if (ASPxClientControl.GetControlCollection().GetByName(controlName)) {
            dropDownViewModel.SelectedId = ASPxClientControl.GetControlCollection().GetByName(controlName).GetValue() || 0;
        }
        if (ownerCbPanel && !ownerCbPanel.InCallback())
            ownerCbPanel.PerformCallback({ strDropDownViewModel: JSON.stringify(dropDownViewModel) });
        if (dropDownViewModel != null
            && dropDownViewModel.ControlAction != null
            && dropDownViewModel.ControlAction === "SysOrgRefRoleId"
            && (ASPxClientControl.GetControlCollection().GetByName(dropDownViewModel.ControlAction) != null)) {
            var ctrlControlAction = ASPxClientControl.GetControlCollection().GetByName(dropDownViewModel.ControlAction);
            ctrlControlAction.PerformCallback({ 'selectedId': 0, 'selectedCountry': '', 'contactId': s.GetValue() });
        }
    }

    var _onAddClick = function (ownerCbPanel, dropDownViewModel, contactRoute) {
        if (RecordPopupControl.IsVisible()) {
            RecordSubPopupControl.callbackCustomArgs["strDropDownViewModel"] = JSON.stringify(dropDownViewModel);
            RecordSubPopupControl.PerformCallback({ strRoute: JSON.stringify(contactRoute), strByteArray: "" });
        } else {
            RecordPopupControl.callbackCustomArgs["strDropDownViewModel"] = JSON.stringify(dropDownViewModel);
            RecordPopupControl.PerformCallback({ strRoute: JSON.stringify(contactRoute), strByteArray: "" });
        }
    }

    var _onNewClick = function (route, strDropDownViewModel) {
        if (!M4PLCommon.CheckHasChanges.CheckDataChanges()) {
            route.RecordId = 0;
            if (ASPxClientControl.GetControlCollection().GetByName('RecordSubPopupControl') && ASPxClientControl.GetControlCollection().GetByName('RecordSubPopupControl').IsVisible()) {
                RecordSubPopupControl.callbackCustomArgs["strDropDownViewModel"] = strDropDownViewModel;
                RecordSubPopupControl.PerformCallback({ strRoute: JSON.stringify(route), strByteArray: "" });
            } else {
                RecordPopupControl.callbackCustomArgs["strDropDownViewModel"] = strDropDownViewModel;
                RecordPopupControl.PerformCallback({ strRoute: JSON.stringify(route), strByteArray: "" });
            }
        } else {
            M4PLCommon.CallerNameAndParameters = { "Caller": _onNewClick, "Parameters": [route] };
            M4PLCommon.CheckHasChanges.ShowConfirmation();
        }
    }

    return {
        init: init,
        OnValueChanged: _onValueChanged,
        OnAddClick: _onAddClick,
        OnNewClick: _onNewClick,
    };
}();

M4PLCommon.CompanyCombobox = function () {
    var params;

    var init = function (p) {
        params = p;
    };

    var _onValueChanged = function (s, e, ownerCbPanel, dropDownViewModel, controlSuffix) {
        var controlName = dropDownViewModel.IsPopup === true ? dropDownViewModel.ControlName + "_popup" : dropDownViewModel.ControlName;
        if (ASPxClientControl.GetControlCollection().GetByName(controlName)) {
            dropDownViewModel.SelectedId = ASPxClientControl.GetControlCollection().GetByName(controlName).GetValue() || 0;
        }
        if (ownerCbPanel && !ownerCbPanel.InCallback())
            ownerCbPanel.PerformCallback({ strDropDownViewModel: JSON.stringify(dropDownViewModel) });
    }

    var _onAddClick = function (ownerCbPanel, dropDownViewModel, contactRoute) {
        if (RecordPopupControl.IsVisible()) {
            RecordSubPopupControl.callbackCustomArgs["strDropDownViewModel"] = JSON.stringify(dropDownViewModel);
            RecordSubPopupControl.PerformCallback({ strRoute: JSON.stringify(contactRoute), strByteArray: "" });
        } else {
            RecordPopupControl.callbackCustomArgs["strDropDownViewModel"] = JSON.stringify(dropDownViewModel);
            RecordPopupControl.PerformCallback({ strRoute: JSON.stringify(contactRoute), strByteArray: "" });
        }
    }

    var _onNewClick = function (route, strDropDownViewModel) {
        if (!M4PLCommon.CheckHasChanges.CheckDataChanges()) {
            route.RecordId = 0;
            if (ASPxClientControl.GetControlCollection().GetByName('RecordSubPopupControl') && ASPxClientControl.GetControlCollection().GetByName('RecordSubPopupControl').IsVisible()) {
                RecordSubPopupControl.callbackCustomArgs["strDropDownViewModel"] = strDropDownViewModel;
                RecordSubPopupControl.PerformCallback({ strRoute: JSON.stringify(route), strByteArray: "" });
            } else {
                RecordPopupControl.callbackCustomArgs["strDropDownViewModel"] = strDropDownViewModel;
                RecordPopupControl.PerformCallback({ strRoute: JSON.stringify(route), strByteArray: "" });
            }
        } else {
            M4PLCommon.CallerNameAndParameters = { "Caller": _onNewClick, "Parameters": [route] };
            M4PLCommon.CheckHasChanges.ShowConfirmation();
        }
    }

    return {
        init: init,
        OnValueChanged: _onValueChanged,
        OnAddClick: _onAddClick,
        OnNewClick: _onNewClick,
    };
}();

M4PLCommon.Attachment = function () {
    // attachment grid batch edit file upload control Start
    var browseClicked = false;

    // To keep track of MaxItemNumber for new row
    var _maxItemNumber = 0;

    //upload control
    var _onFileUploadComplete = function (s, e, fieldName, gridView) {
        gridView.batchEditApi.SetCellValue($("#gvVisibleIndex").val(), fieldName, e.callbackData);
        gridView.batchEditApi.EndEdit();
        DevExCtrl.LoadingPanel.Hide(GlobalLoadingPanel);
    }

    var _onFileUploadStart = function (s, e) {
        DevExCtrl.LoadingPanel.Show(GlobalLoadingPanel);
    }

    var _onTextChanged = function (s, e) {
        if (s.GetText()) {
            browseClicked = true;
            s.Upload();
        }
    }
    var _setUCText = function (text, ucFieldName) {
        var $input = $("input:visible[type=text]", ucFieldName.GetMainElement());
        $input.val(text);
    }

    //grid
    var _onBatchStartEditing = function (s, e, fieldName, itemNumberFieldName, uploadControl, isReadOnly) {
        e.cancel = (isReadOnly === 'True') ? true : false;
        if (!e.cancel) {
            browseClicked = false;
            $("#gvVisibleIndex").val(e.visibleIndex);
            if (e.visibleIndex < 0) {
                $("#hf").val(e.visibleIndex);
                if (!e.rowValues[s.GetColumnByField(itemNumberFieldName).index].value) {
                    e.rowValues[s.GetColumnByField(itemNumberFieldName).index].value = _maxItemNumber;
                    _maxItemNumber += 1;
                }
            } else
                $("#hf").val(s.GetRowKey(e.visibleIndex));

            var fileNameColumn = s.GetColumnByField(fieldName);
            if (!e.rowValues.hasOwnProperty(fileNameColumn.index))
                return;
            var cellInfo = e.rowValues[fileNameColumn.index];

            setTimeout(function () {
                _setUCText(cellInfo.value, uploadControl);
            }, 0);
        }
    }
    var _onBatchEditEndEditing = function OnBatchEditEndEditing(s, e) {
        browseClicked = false;
        _setUCText("", ucAttFileName);
        window.setTimeout(function () { _setCustomButtonsVisibility(s, e); }, 0);
    }

    var _onBatchConfirm = function OnBatchConfirm(s, e) {
        e.cancel = browseClicked;
    }
    // attachment grid batch edit file upload control END

    var _beginCallback = function (s, e, route) {
        e.customArgs["strRoute"] = route;
    }

    var _downloadAttachment = function (s, e, downloadUrl, updateDownloadUrl, currentGridControlName, recordId) {
        $.ajax({
            type: "POST",
            url: updateDownloadUrl + "?recordId=" + recordId + "&currentDateTime=" + moment.now(),
            async: true,
            contentType: false,
            processData: false,
            success: function (response) {
                ASPxClientControl.GetControlCollection().GetByName(currentGridControlName).PerformCallback();
                window.location = downloadUrl + "?recordId=" + recordId;
            }
        });
    }

    var _onEndCallBack = function (s, e, ownerCbPanel, isPopup) {
        if (s && (s.cpMaxItemNumber != null))
            _maxItemNumber = Number(s.cpMaxItemNumber);
        if (s && (s.cpAttachmentHeaderText != null))
            pnlCreAttachment.SetHeaderText(s.cpAttachmentHeaderText);
        _setCustomButtonsVisibility(s, e);
        if (ownerCbPanel && isPopup && (isPopup === 'True') && ASPxClientControl.GetControlCollection().GetByName(ownerCbPanel) && !ASPxClientControl.GetControlCollection().GetByName(ownerCbPanel).InCallback()) {
            ASPxClientControl.GetControlCollection().GetByName(ownerCbPanel).PerformCallback();
        }
        M4PLCommon.Error.CheckServerError();
    }

    var _onInit = function (s, e) {
        if (s && (s.cpMaxItemNumber != null))
            _maxItemNumber = Number(s.cpMaxItemNumber);
        if (s && (s.cpAttachmentHeaderText != null))
            pnlCreAttachment.SetHeaderText(s.cpAttachmentHeaderText);
        //_maxItemNumber = maxItemNumber;
        _setCustomButtonsVisibility(s, e);
    }

    var _onUpdateEdit = function (grid, e) {
        grid.UpdateEdit();
    }

    var _onCancelEdit = function (grid, maxItemNumber, e) {
        _maxItemNumber = maxItemNumber;
        grid.CancelEdit();
        _setCustomButtonsVisibility(grid, e);
    }

    var _setCustomButtonsVisibility = function (s, e) {
        var statusBar = s.GetMainElement().getElementsByClassName("AttachmentStatusBarWithButtons");
        if (statusBar.length > 0) {
            var btnBar = statusBar[0].getElementsByTagName("td")[0];
            if (!s.batchEditApi.HasChanges())
                btnBar.style.visibility = "hidden";
            else
                btnBar.style.visibility = "visible";
        }
    }

    var _onCustomButtonClick = function (s, e) {
        if (e.buttonID && e.buttonID == "attachmentDeleteButton") {
            s.DeleteRow(e.visibleIndex);
            _setCustomButtonsVisibility(s, e);
        }
    }

    return {
        FileUploadTextChanged: _onTextChanged,
        FileUploadComplete: _onFileUploadComplete,
        FileUploadStart: _onFileUploadStart,
        BatchStartEditing: _onBatchStartEditing,
        BatchConfirm: _onBatchConfirm,
        BatchEditEndEditing: _onBatchEditEndEditing,
        AttachmentBeginCallback: _beginCallback,
        DownloadAttachment: _downloadAttachment,
        EndCallBack: _onEndCallBack,
        OnInit: _onInit,
        OnUpdateEdit: _onUpdateEdit,
        OnCancelEdit: _onCancelEdit,
        OnCustomButtonClick: _onCustomButtonClick
    };
}();

M4PLCommon.NavigationBanner = function () {
    var _itemClick = function (s, e, gridCtrl) {
        if (!M4PLCommon.CheckHasChanges.CheckDataChanges()) {
            var currentRoute = JSON.parse(e.item.name);
            $.ajax({
                type: "POST",
                url: "/" + currentRoute.Area + "/" + currentRoute.Controller + "/" + currentRoute.Action,
                data: { strFormNavMenu: e.item.name },
                success: function (response) {
                    if (response.route.IsPopup && response.route.IsPopup === true) {
                        RecordPopupControl.PerformCallback({ strRoute: JSON.stringify(response.route), strByteArray: "" });
                    } else {
                        if (response.route.OwnerCbPanel)
                            ASPxClientControl.GetControlCollection().GetByName(response.route.OwnerCbPanel).PerformCallback({ strRoute: JSON.stringify(response.route) });
                        else
                            AppCbPanel.PerformCallback({ strRoute: JSON.stringify(response.route) });
                    }
                }
            });
        } else {
            M4PLCommon.CallerNameAndParameters = { "Caller": _itemClick, "Parameters": [s, e] };
            M4PLCommon.CheckHasChanges.ShowConfirmation();
        }
    }

    var _secondNavClick = function (s, e) {
        eval(e.item.name);
    }

    return {
        ItemClick: _itemClick,
        SecondNavClick: _secondNavClick
    }
}();

M4PLCommon.SessionTimeout = (function () {
    var _timeLeft, _popupTimer, _countDownTimer;
    var stopTimers = function () {
        window.clearTimeout(_countDownTimer);
    };
    var _init = function () {
    };

    var _updateCountDown = function () {
        var min = Math.floor(_timeLeft / 60);
        var sec = _timeLeft % 60;
        if (sec < 10)
            sec = "0" + sec;
        $("#CountDownHolder").html(min + ":" + sec)
        document.getElementById("CountDownHolder").innerHTML = min + ":" + sec;

        if (_timeLeft > 0) {
            _timeLeft--;
            _countDownTimer = window.setTimeout(_updateCountDown, 1000);
        } else {
            window.location = "/Account/LogOut";
        }
    };

    var _showPopup = function (warningTime, contentUrl) {
        _timeLeft = 60 * (warningTime);

        DisplayMessageControl.callbackCustomArgs["strDisplayMessage"] = contentUrl;
        DisplayMessageControl.closeAction = "None";
        DisplayMessageControl.PerformCallback();

        var updateInterval = window.setInterval(function () {
            if (DisplayMessageControl.IsVisible() && typeof CountDownHolder !== undefined) {
                _updateCountDown();
                window.clearInterval(updateInterval);
            }
        }, '1000');
    };

    var _schedulePopup = function () {
        stopTimers();
        var sessionTimer = window.setInterval(function () {
            $.ajax({
                url: '/Common/GetLastCallDateTime',
                type: "GET",
                async: true,
                success: function (data) {
                    if (data.showAlert && !DisplayMessageControl.IsVisible()) {
                        _showPopup(data.warningTime, data.strDisplayMessage);
                    } else {
                        //window.clearInterval(sessionTimer);
                    }
                }
            });
        }, 300000);
    };

    var _sendKeepAlive = function () {
        stopTimers();
        DisplayMessageControl.Hide();
        _schedulePopup();
    };

    var _updateSessionTimeOut = function () {
        $.ajax({
            url: '/Common/UpdateUserSession',
            type: "GET",
            async: true,
            success: function (data) {
                DisplayMessageControl.Hide();
            }
        });
    }

    return {
        Init: _init,
        SchedulePopup: _schedulePopup,
        SendKeepAlive: _sendKeepAlive,
        UpdateSessionTime: _updateSessionTimeOut,
        UpdateCountDown: _updateCountDown
    };
})();

M4PLCommon.WindowService = (function () {
    var _enumCustomCommand = { "Notepad": 128, "Calculator": 240, "Skype": 233 };

    var _onInitiateActionClick = function (commandId) {
        var result = false;
        $.ajax({
            type: "GET",
            cache: false,
            url: "http://localhost:56147/AppBridge/InitiateAction/" + commandId,
            contentType: 'application/json; charset=utf-8',
            async: false,
            processData: false,
            success: function (response) {
                result = response;
                if (!result && (commandId == _enumCustomCommand.Skype))
                    alert('Please install Skype and try again');
            },
            error: function (err) {
                alert('Please install M4PL Executor Service first. You can download it from, Preferences > Download Executor');
            },
            failure: function (err) {
                alert('Please install M4PL Executor Service first. You can download it from, Preferences > Download Executor');
            }
        });
        return result;
    }

    var _onSyncOutlookClick = function (authToken, baseUrl, statusIdToAssign) {
        var argumentsToSend = { AuthToken: authToken, AddContactBaseUrl: baseUrl, StatusIdToAssign: statusIdToAssign };
        $.ajax({
            type: "GET",
            url: "http://localhost:56147/AppBridge/SyncOutlookContacts?allArgument=" + JSON.stringify(argumentsToSend),
            success: function (response) {
                if (response)
                    alert('Outlook Sync Done');
                else
                    alert("You don't have outlook installed in your system.");
            },
            error: function (err) {
                alert('Please install M4PL Executor Service first. You can download it from, Preferences > Download Executor');
            },
            failure: function (err) {
                alert('Please install M4PL Executor Service first. You can download it from, Preferences > Download Executor');
            }
        });
    }

    return {
        EnumCustomCommand: _enumCustomCommand,
        OnInitiateActionClick: _onInitiateActionClick,
        OnSyncOutlookClick: _onSyncOutlookClick
    }
})();

M4PLCommon.Control = (function () {
    var _onGotFocus = function (s, e, removeCtrlName) {
        if (s && !removeCtrlName)
            M4PLCommon.FocusedControlName = s.name;
        if (removeCtrlName)
            M4PLCommon.FocusedControlName = null;
    }

    var _getSelectedText = function () {
        var selectedText = "";
        if (M4PLCommon.FocusedControlName) {
            var currentControl = ASPxClientControl.GetControlCollection().GetByName(M4PLCommon.FocusedControlName);
            //For TextBox
            if (currentControl.GetChildElement('I')) {
                var textComponent = document.getElementById($(currentControl.GetChildElement('I')).attr('id'));
                if (textComponent.selectionStart !== undefined) {
                    // Standards Compliant Version
                    var startPos = textComponent.selectionStart;
                    var endPos = textComponent.selectionEnd;
                    if (startPos == endPos)
                        selectedText = textComponent.value;
                    else
                        selectedText = textComponent.value.substring(startPos, endPos);
                }
                else if (document.selection !== undefined) {
                    // IE Version
                    textComponent.focus();
                    var sel = document.selection.createRange();
                    selectedText = sel.text;
                }
            }
            //For RichTextBox
            if (currentControl.selection && currentControl.document) {
                var firstSelectedInterval = currentControl.selection.intervals[0];
                selectedText = currentControl.document.activeSubDocument.text.substr(firstSelectedInterval.start, firstSelectedInterval.length);
            }
        }
        return selectedText;
    }

    var _updateSelectedText = function () {
        if (M4PLCommon.FocusedControlName) {
            var currentControl = ASPxClientControl.GetControlCollection().GetByName(M4PLCommon.FocusedControlName);
            M4PLCommon.Clipboard.GetClipboard(document.getElementById(currentControl), true);
        }
    }

    var _onTextChanged = function () {
        if (ASPxClientControl.GetControlCollection().GetByName('RecordSubPopupControl') && ASPxClientControl.GetControlCollection().GetByName('RecordSubPopupControl').IsVisible())
            M4PLWindow.SubPopupFormViewHasChanges = true;
        else if (ASPxClientControl.GetControlCollection().GetByName('RecordPopupControl') && ASPxClientControl.GetControlCollection().GetByName('RecordPopupControl').IsVisible())
            M4PLWindow.PopupFormViewHasChanges = true;
        else if (ASPxClientControl.GetControlCollection().GetByName('RprtName') && ASPxClientControl.GetControlCollection().GetByName('RprtName').IsValueChanged())
            M4PLWindow.FormViewHasChanges = false;
        else
            M4PLWindow.FormViewHasChanges = true;
    }

    var _updateDataViewHasChanges = function (dataViewName, currentStatus) {
        M4PLCommon.IsIgnoreClick = false;
        if (ASPxClientControl.GetControlCollection().GetByName('RecordPopupControl') && ASPxClientControl.GetControlCollection().GetByName('RecordPopupControl').IsVisible())
            M4PLWindow.PopupDataViewHasChanges[dataViewName] = currentStatus;
        else if ($('div[id^="btn"][id$="Save"]').length > 0) {
            M4PLWindow.SubDataViewsHaveChanges[dataViewName] = currentStatus;
            M4PLWindow.PopupDataViewHasChanges[dataViewName] = currentStatus;
        }
        else
            M4PLWindow.DataViewsHaveChanges[dataViewName] = currentStatus;
    }

    var _updateFormViewHasChangesWithDefaultValue = function () {
        if (ASPxClientControl.GetControlCollection().GetByName('RecordSubPopupControl') && ASPxClientControl.GetControlCollection().GetByName('RecordSubPopupControl').IsVisible())
            M4PLWindow.SubPopupFormViewHasChanges = false;
        else if (ASPxClientControl.GetControlCollection().GetByName('RecordPopupControl') && ASPxClientControl.GetControlCollection().GetByName('RecordPopupControl').IsVisible())
            M4PLWindow.PopupFormViewHasChanges = false;
        else
            M4PLWindow.FormViewHasChanges = false;
    }

    return {
        OnGotFocus: _onGotFocus,
        GetSelectedText: _getSelectedText,
        UpdateSelectedText: _updateSelectedText,
        OnTextChanged: _onTextChanged,
        UpdateDataViewHasChanges: _updateDataViewHasChanges,
        UpdateFormViewHasChangesWithDefaultValue: _updateFormViewHasChangesWithDefaultValue
    }
})();

M4PLCommon.CheckHasChanges = (function () {
    var _checkDataChanges = function (currentGridName) {
        var hasDataChanged = false;

        if (!currentGridName) {
            if (ASPxClientControl.GetControlCollection().GetByName('RecordSubPopupControl') && ASPxClientControl.GetControlCollection().GetByName('RecordSubPopupControl').IsVisible()) {
                hasDataChanged = M4PLWindow.SubPopupFormViewHasChanges;
            } else if (ASPxClientControl.GetControlCollection().GetByName('RecordPopupControl') && ASPxClientControl.GetControlCollection().GetByName('RecordPopupControl').IsVisible()) {
                var chqCtrl = ASPxClientControl.GetControlCollection().GetByName('ChequeNo');
                if (chqCtrl != null && chqCtrl != undefined) {
                    M4PLWindow.PopupFormViewHasChanges = false;
                }
                hasDataChanged = M4PLWindow.PopupFormViewHasChanges;
                if (!hasDataChanged) {
                    for (var gridName in M4PLWindow.PopupDataViewHasChanges) {
                        if (M4PLWindow.PopupDataViewHasChanges.hasOwnProperty(gridName) && M4PLWindow.PopupDataViewHasChanges[gridName])
                            hasDataChanged = true;
                    }
                }
            } else {
                if (!hasDataChanged) {
                    for (var gridName in M4PLWindow.SubDataViewsHaveChanges) {
                        if (M4PLWindow.SubDataViewsHaveChanges.hasOwnProperty(gridName) && M4PLWindow.SubDataViewsHaveChanges[gridName])
                            hasDataChanged = true;
                    }
                }
                if (!hasDataChanged)
                    hasDataChanged = M4PLWindow.FormViewHasChanges;
                if (!hasDataChanged) {
                    for (var gridName in M4PLWindow.DataViewsHaveChanges) {
                        if (M4PLWindow.DataViewsHaveChanges.hasOwnProperty(gridName) && M4PLWindow.DataViewsHaveChanges[gridName])
                            hasDataChanged = true;
                    }
                }
            }
        } else {
            if (M4PLWindow.SubDataViewsHaveChanges.hasOwnProperty(currentGridName) && M4PLWindow.SubDataViewsHaveChanges[currentGridName]) {
                hasDataChanged = true;
                M4PLCommon.IsFromSubTabCancelClick = true;
            }
            if (M4PLWindow.DataViewsHaveChanges.hasOwnProperty(currentGridName) && M4PLWindow.DataViewsHaveChanges[currentGridName])
                hasDataChanged = true;
            if (M4PLWindow.PopupDataViewHasChanges.hasOwnProperty(currentGridName) && M4PLWindow.PopupDataViewHasChanges[currentGridName])
                hasDataChanged = true;
        }

        //Below for ReportDesigner to check that user has unsaved data or not.
        if (ASPxClientControl.GetControlCollection().GetByName('ReportDesigner')) {
            hasDataChanged = ASPxClientControl.GetControlCollection().GetByName('ReportDesigner').GetDesignerModel().isDirty();
        }

        //Below for Dashboard to check that user has unsaved data or not.
        if (ASPxClientControl.GetControlCollection().GetByName('Dashboard')) {
            hasDataChanged = ASPxClientControl.GetControlCollection().GetByName('Dashboard').GetDashboardControl().undoEngine().isDirty();
        }

        if (ASPxClientControl.GetControlCollection().GetByName('pnlReportSurveyAction')) {
            hasDataChanged = M4PLWindow.FormViewHasChanges = false;
        }
        if (ASPxClientControl.GetControlCollection().GetByName('pnlJobAdvanceReport')) {
            hasDataChanged = M4PLWindow.FormViewHasChanges = false;
        }
        if (ASPxClientControl.GetControlCollection().GetByName('JobCardViewTileCbPanel')) {
            hasDataChanged = M4PLWindow.FormViewHasChanges = false;
        }

        if (ASPxClientControl.GetControlCollection().GetByName('AppCbPanel') && M4PLCommon.IsIgnoreCardGridClick) {
            hasDataChanged = M4PLWindow.FormViewHasChanges = false;
            M4PLCommon.IsIgnoreCardGridClick = false;
        }
        if (M4PLCommon.IsIgnoreClick) {
            hasDataChanged = false;
            M4PLWindow.SubDataViewsHaveChanges[currentGridName] = false;
            M4PLWindow.PopupDataViewHasChanges[currentGridName] = false;
            M4PLWindow.DataViewsHaveChanges[currentGridName] = false;
        }
        return hasDataChanged;
    }

    var _onIgnoreChanges = function () {
        if (ASPxClientControl.GetControlCollection().GetByName('RecordSubPopupControl') && ASPxClientControl.GetControlCollection().GetByName('RecordSubPopupControl').IsVisible()) {
            M4PLWindow.SubPopupFormViewHasChanges = false;
        } else if (ASPxClientControl.GetControlCollection().GetByName('RecordPopupControl') && ASPxClientControl.GetControlCollection().GetByName('RecordPopupControl').IsVisible()) {
            M4PLWindow.PopupFormViewHasChanges = false;
            M4PLWindow.PopupDataViewHasChanges = {};
        } else {
            if (M4PLWindow.SubDataViewsHaveChanges) {
                for (var gridName in M4PLWindow.SubDataViewsHaveChanges) {
                    if (M4PLWindow.SubDataViewsHaveChanges.hasOwnProperty(gridName) && M4PLWindow.SubDataViewsHaveChanges[gridName]) {
                        var currentGrid = ASPxClientControl.GetControlCollection().GetByName(gridName);
                        if (currentGrid) {
                            currentGrid.CancelEdit();
                            //M4PLWindow.DataView.SetCustomButtomVisibility(currentGrid, null);
                            M4PLWindow.PopupDataViewHasChanges[currentGrid] = false;
                            M4PLWindow.DataViewsHaveChanges[currentGrid] = false;
                        }
                    }
                }
                M4PLWindow.SubDataViewsHaveChanges = {};
                DisplayMessageControl.Hide();
            }
            if (!M4PLCommon.IsFromSubTabCancelClick) {
                M4PLWindow.FormViewHasChanges = false;
                M4PLWindow.DataViewsHaveChanges = {};
            } else
                M4PLCommon.IsFromSubTabCancelClick = false;
        }

        //Special case for Report Designer
        if (ASPxClientControl.GetControlCollection().GetByName('ReportDesigner') && ASPxClientControl.GetControlCollection().GetByName('ReportDesigner').IsModified())
            ASPxClientControl.GetControlCollection().GetByName('ReportDesigner') && ASPxClientControl.GetControlCollection().GetByName('ReportDesigner').ResetIsModified();

        //Below for Dashboard to check that user has unsaved data or not.
        if (ASPxClientControl.GetControlCollection().GetByName('Dashboard'))
            ASPxClientControl.GetControlCollection().GetByName('Dashboard').GetDashboardControl().close();

        M4PLCommon.IsIgnoreClick = true;
        DisplayMessageControl.Hide();
        _redirectToClickedItem();
    }

    var _redirectToClickedItem = function () {
        if (M4PLCommon.CallerNameAndParameters.Caller) {
            if (M4PLCommon.IsFromSubDataViewSaveClick && (M4PLCommon.CallerNameAndParameters.Caller.name != "_onManualTabClick") && (M4PLCommon.CallerNameAndParameters.Caller.name != "_onCancelEdit")) {
                M4PLCommon.IsFromSubDataViewSaveClick = false;
                $('div[id^="btn"][id$="Save"]').trigger('click');
                M4PLWindow.IsFromConfirmSaveClick = true;
            }
            else {
                if (M4PLCommon.CallerNameAndParameters.Parameters.length < 6) {
                    for (var i = M4PLCommon.CallerNameAndParameters.Parameters.length; i < 6; i++)
                        M4PLCommon.CallerNameAndParameters.Parameters[i] = null;
                }

                //IMPORTANT -> Here assuming that we won't have more then 5 parameters. So, If anywhere using more then 6 then need to increase here as well.
                M4PLCommon.CallerNameAndParameters.Caller(M4PLCommon.CallerNameAndParameters.Parameters[0], M4PLCommon.CallerNameAndParameters.Parameters[1],
                    M4PLCommon.CallerNameAndParameters.Parameters[2], M4PLCommon.CallerNameAndParameters.Parameters[3], M4PLCommon.CallerNameAndParameters.Parameters[4], M4PLCommon.CallerNameAndParameters.Parameters[5]);

                M4PLCommon.CallerNameAndParameters = { "Caller": null, "Parameters": [] };
            }
        }
    }

    var _onShowConfirmation = function () {
        $.ajax({
            type: "GET",
            url: "/Common/ShowConfirmationMessage",
            success: function (response) {
                DisplayMessageControl.PerformCallback({ strDisplayMessage: response.DisplayMessage });
            },
            error: function () {
            }
        });
    }

    var _onSaveChangesAndProceed = function () {
        DisplayMessageControl.Hide();
        if (M4PLWindow.SubPopupFormViewHasChanges) {
            /*For RecordSubPopup Page*/
            $('.popupSaveButton').eq(1).trigger('click');
        } else if (M4PLWindow.PopupFormViewHasChanges) {
            /*For RecordPopup Page*/
            $('.popupSaveButton').eq(0).trigger('click');
        } else if (M4PLWindow.SubDataViewsHaveChanges) {
            /* For Sub Data View inside Form View*/
            var isSaveRequired = false;
            var currentGridName = null;
            for (var gridName in M4PLWindow.SubDataViewsHaveChanges) {
                if (M4PLWindow.SubDataViewsHaveChanges.hasOwnProperty(gridName) && M4PLWindow.SubDataViewsHaveChanges[gridName]) {
                    isSaveRequired = true;
                    currentGridName = gridName;
                }
            }
            if (isSaveRequired && ASPxClientControl.GetControlCollection().GetByName('pageControl')) {
                var currentId = "btnSave" + currentGridName;
                $('#pageControl_C' + pageControl.activeTabIndex).find('div[id="' + currentId + '"]').trigger('click');
                M4PLWindow.IsFromConfirmSaveClick = true;
                M4PLCommon.IsFromSubDataViewSaveClick = true;
                M4PLCommon.IsFromSubTabCancelClick = false;
            } else if (M4PLWindow.FormViewHasChanges) {
                /*For FormView Page*/
                $('div[id^="btn"][id$="Save"]').trigger('click');
                M4PLWindow.IsFromConfirmSaveClick = true;
            } else if (M4PLWindow.DataViewsHaveChanges) {
                /*For DataView Page*/
                $('div[id^="btnSave"][id$="GridView"]').trigger('click');
                M4PLWindow.IsFromConfirmSaveClick = true;
            }
        }
    }

    var _onIsAdminChanges = function (input, strRoute) {
        M4PLWindow.IsFromConfirmSaveClick = true;
        DisplayMessageControl.Hide();
        $.ajax({
            traditional: true,
            type: "POST",
            url: "/SystemAccount/AddOrEdit",
            data: input,
            contentType: 'application/json; charset=utf-8',
            success: function (response) {
                var isFromConfirmSave = M4PLWindow.IsFromConfirmSaveClick;
                M4PLWindow.IsFromConfirmSaveClick = false;
                if (response && response.status && response.status === true) {
                    if (response.redirectLogin !== undefined && response.redirectLogin) {
                        window.location.href = "/Account/Logout";
                        return;
                    }
                    M4PLCommon.CurrentByteArrayCount = 0;
                    if (response.byteArray && response.byteArray.length > 0 && response.route) {
                        M4PLCommon.RichEdit.RichEditorsPerformCallBack(response.route, response.byteArray, null);
                    }
                    var formInterval = setInterval(function () {
                        if ((M4PLCommon.CurrentByteArrayCount <= 0) && AppCbPanel && !AppCbPanel.InCallback()) {
                            window.clearInterval(formInterval);
                            var route = JSON.parse(strRoute);
                            if (response.reloadApplication && response.reloadApplication === true) {
                                M4PLCommon.Common.ReloadApplication();
                                return;
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
            },
            error: function () {
            }
        });
    }

    var _onIsAdminChangesDataView = function (input, strRoute, gridName) {
        //alert(input);
        DisplayMessageControl.Hide();
        $.ajax({
            type: "POST",
            url: "/SystemAccount/DataViewBatchUpdateOnSysAdminChange",
            data: { 'input': input, 'strRoute': JSON.stringify(strRoute), 'gridName': gridName },
            dataType: 'json',
            success: function (response) {
            },
            error: function () {
            }
        });
    }

    return {
        CheckDataChanges: _checkDataChanges,
        OnIgnoreChanges: _onIgnoreChanges,
        ShowConfirmation: _onShowConfirmation,
        RedirectToClickedItem: _redirectToClickedItem,
        OnSaveChangesAndProceed: _onSaveChangesAndProceed,
        OnIsAdminChanges: _onIsAdminChanges,
        OnIsAdminChangesDataView: _onIsAdminChangesDataView
    }
})();

M4PLCommon.NavSync = (function () {
    var _navradioselected = function (ErpId) {
        var selectedTxtBox = ASPxClientControl.GetControlCollection().GetByName('ERPId');
        if (selectedTxtBox == null)
            selectedTxtBox = ASPxClientControl.GetControlCollection().GetByName('ERPId_popup');
        if (selectedTxtBox != null)
            selectedTxtBox.SetValue(ErpId)
    }

    var _navBarIndexSelect = function (groupName, itemText) {
        var navMenu = ASPxClientControl.GetControlCollection().GetByName('M4PLNavBar');
        if (navMenu !== null) {
            var navGroup = navMenu.GetGroupByName(groupName);
            if (navGroup !== null)
                for (var i = 0; i < navGroup.GetItemCount(); i++) {
                    var current = navGroup.GetItem(i);
                    if (current.GetText() == itemText) {
                        navMenu.SetSelectedItem(current);
                    }
                }
        }
    }

    return {
        NAVRadioSelected: _navradioselected,
        NavBarIndexSelect: _navBarIndexSelect
    };
})();

M4PLCommon.InformationPopup = (function () {
    var _navSyncSuccessResponse = function (routUrl) {
        $.ajax({
            type: "GET",
            url: routUrl,
            success: function (response) {
                console.log(response);
                DisplayMessageControl.PerformCallback({ strDisplayMessage: JSON.stringify(response.displayMessage) });
                if (response.route.EntityName == "Job") {
                    DevExCtrl.Ribbon.DoCallBack(response.route);
                }
                else {
                    AppCbPanel.PerformCallback({ strRoute: JSON.stringify(response.route) });
                }
            }
        });
    };

    return {
        NAVSyncSuccessResponse: _navSyncSuccessResponse
    };
})();

M4PLCommon.VocReport = (function () {
    var _pbsCheckBoxEventChange = function (s, e) {
        var customerCtrl = ASPxClientControl.GetControlCollection().GetByName('Customer');
        var locationCtrl = ASPxClientControl.GetControlCollection().GetByName('CustomerLocationCbPanel');

        if (customerCtrl != null && locationCtrl != null) {
            customerCtrl.SetVisible(!s.GetValue());
            locationCtrl.SetVisible(!s.GetValue());
            if (s.GetValue()) {
                $(".IsReportJob").hide();
            }
            else {
                $(".IsReportJob").show();
            }
        }
    };

    var _getVocReportByFilter = function (s, e, rprtVwrCtrl, rprtVwrRoute) {
        if (rprtVwrCtrl) {
            if ($('.errorMessages') != undefined) {
                $('.errorMessages').html('');
            }

            rprtVwrRoute.RecordId = 0;
            var customerCtrl = ASPxClientControl.GetControlCollection().GetByName('Customer');
            var locationCtrl = ASPxClientControl.GetControlCollection().GetByName('CustomerLocationCbPanelClosed');
            var startDateCtrl = ASPxClientControl.GetControlCollection().GetByName('StartDate');
            var endDateCtrl = ASPxClientControl.GetControlCollection().GetByName('EndDate');
            var pbsCheckBoxCtrl = ASPxClientControl.GetControlCollection().GetByName('IsPBSReport');
            var CompanyId = "";
            var location = "";
            var startDate = "";
            var endDate = "";
            var isPBSReport = false;

            if (customerCtrl != null)
                CompanyId = customerCtrl.GetValue();
            if (locationCtrl != null)
                if (locationCtrl.GetValue() != null && locationCtrl != undefined && locationCtrl.GetValue() != "ALL")
                    rprtVwrRoute.Location = locationCtrl.GetValue().split(',').map(String);
            if (startDateCtrl != null)
                startDate = startDateCtrl.GetValue();
            if (endDateCtrl != null)
                endDate = endDateCtrl.GetValue();
            if (pbsCheckBoxCtrl != null)
                isPBSReport = pbsCheckBoxCtrl.GetValue();

            rprtVwrRoute.CompanyId = CompanyId;
            rprtVwrRoute.StartDate = startDate;
            rprtVwrRoute.EndDate = endDate;
            rprtVwrRoute.IsPBSReport = isPBSReport;
            var IsFormValidate = true;
            if ((startDate != "" && endDate != "" && startDate != null && endDate != null) && new Date(startDate) > new Date(endDate)) {
                if ($('.errorMessages') != undefined) {
                    $('.errorMessages').append('<p>* End date should be greater than start date.</p>');
                }
                IsFormValidate = false;
            }

            if (!isPBSReport) {
                if (CompanyId != 0 && (CompanyId == "" || CompanyId == null)) {
                    if ($('.errorMessages') != undefined) {
                        $('.errorMessages').append('<p>* Please select any customer..</p>');
                    }
                    IsFormValidate = false;
                }
            }
            if (IsFormValidate) {
                $.ajax({
                    url: "/Job/JobReport/FilterVOCReportViewer",
                    data: { strRoute: JSON.stringify(rprtVwrRoute) },
                    type: "POST",
                    dataType: "JSON",
                    success: function (response) {
                        if (response != null) {
                            rprtVwrCtrl.PerformCallback({ strRoute: JSON.stringify(response) });
                        }
                    },
                    error: function (error) {
                        console.log(error);
                    },
                });
                //rprtVwrCtrl.PerformCallback({ strRoute: JSON.stringify(rprtVwrRoute) });
            }
            else {
                return false;
            }
        }
    };

    var _defaultSelectedLocation = function (s, e) {
        s.SetSelectedIndex(0);
    }

    var _defaultSelectedCustomer = function (s, e, timeOut, cardVwrRoute) {
        if (cardVwrRoute != null && cardVwrRoute != undefined && cardVwrRoute.CompanyId > 0)
            console.log('');
        else
            s.SetSelectedIndex(0);
        _addAutoRefresh(s, e, timeOut, cardVwrRoute);
    }
    var _getValueByText = function (texts, checkListBox) {
        var actualValues = null;
        var items;
        items = checkListBox.GetSelectedItems();
        if (texts != null) {
            for (var i = 0; i < items.length; i++) {
                if (items[i].text == texts) {
                    actualValues = items[i].value;
                    break;
                }
            }
        }
        return actualValues;
    }
    var _getJobCardByFilter = function (s, e, cardVwrCtrl, cardVwrRoute) {
        var checkListBox = ASPxClientControl.GetControlCollection().GetByName('checkListBoxDestinationByCustomerCbPanelforClosed');
        var destinationCtrl = ASPxClientControl.GetControlCollection().GetByName('DestinationByCustomerCbPanelforClosed');
        if (destinationCtrl && checkListBox != null && destinationCtrl && destinationCtrl != null) {
            var selectedItems = checkListBox.GetSelectedItems();
            if (selectedItems == null || selectedItems == undefined || selectedItems.length == 0) {
                checkListBox.SelectAll();
                destinationCtrl.SetText(M4PLCommon.DropDownMultiSelect.GetSelectedItemsVal(selectedItems, checkListBox));
                destinationCtrl.DropDown.FireEvent(s, e);
            }
        }
        DevExCtrl.LoadingPanel.Show(GlobalLoadingPanel);
        cardVwrRoute.RecordId = ASPxClientControl.GetControlCollection().GetByName('Customer').GetValue() || 0;
        if (destinationCtrl != null)
            if (destinationCtrl.GetValue() != null && destinationCtrl.GetValue() != undefined) {
                var dest = destinationCtrl.GetValue().split(',').map(String);//resetVal(destinationCtrl.GetValue(), checkListBoxDestinationByCustomerCbPanelforClosed);
                cardVwrRoute.Location = [];
                if (checkListBox != null && checkListBox != undefined)
                    $.each(dest, function (key, value) {
                        cardVwrRoute.Location.push(_getValueByText(value, checkListBox));
                    });
                //cardVwrRoute.Location = dest;
            }

        cardVwrCtrl.PerformCallback({ strRoute: JSON.stringify(cardVwrRoute) });
    }

    var _onCardDataViewClick = function (s, e, form, strRoute) {
        var route = JSON.parse(strRoute);
        var checkListBox = ASPxClientControl.GetControlCollection().GetByName('checkListBoxDestinationByCustomerCbPanelforClosed');
        var destinationCtrl = ASPxClientControl.GetControlCollection().GetByName('DestinationByCustomerCbPanelforClosed');
        if (destinationCtrl != null)
            if (destinationCtrl.GetValue() != null && destinationCtrl.GetValue() != undefined) {
                var dest = destinationCtrl.GetValue().split(',').map(String);
                route.Location = [];
                if (checkListBox != null && checkListBox != undefined)
                    $.each(dest, function (key, value) {
                        route.Location.push(_getValueByText(value, checkListBox));
                    });
                //route.Location = dest;
            }
        var dashCategoryRelationId = CardView.GetCardKey(s.GetFocusedCardIndex());
        var customerCtrl = ASPxClientControl.GetControlCollection().GetByName('Customer');
        route.CompanyId = customerCtrl.GetValue();
        M4PLCommon.IsIgnoreCardGridClick = true;
        if (ASPxClientControl.GetControlCollection().GetByName(route.OwnerCbPanel) != null && !ASPxClientControl.GetControlCollection().GetByName(route.OwnerCbPanel).InCallback()) {
            ASPxClientControl.GetControlCollection().GetByName(route.OwnerCbPanel).PerformCallback({ strRoute: JSON.stringify(route), gridName: '', filterId: dashCategoryRelationId });
        }

        DevExCtrl.Ribbon.DoCallBack(route);
    }
    var _onClickCardTileRefresh = function (s, e, rprtVwrCtrl, rprtVwrRoute) {
        DevExCtrl.LoadingPanel.Show(GlobalLoadingPanel);
        var customerCtrl = ASPxClientControl.GetControlCollection().GetByName('Customer');
        rprtVwrRoute.RecordId = customerCtrl.GetValue() || 0;

        var destinationCtrl = ASPxClientControl.GetControlCollection().GetByName('DestinationByCustomerCbPanelforClosed');
        if (destinationCtrl != null)
            if (destinationCtrl.GetValue() != null && destinationCtrl.GetValue() != undefined) {
                var dest = destinationCtrl.GetValue().split(',').map(String);//resetVal(destinationCtrl.GetValue(), checkListBoxDestinationByCustomerCbPanelforClosed);
                var checkListBox = ASPxClientControl.GetControlCollection().GetByName('checkListBoxDestinationByCustomerCbPanelforClosed');
                rprtVwrRoute.Location = [];
                if (checkListBox != null && checkListBox != undefined)
                    $.each(dest, function (key, value) {
                        rprtVwrRoute.Location.push(_getValueByText(value, checkListBox));
                    });
                //rprtVwrRoute.Location = dest;
            }

        rprtVwrCtrl.PerformCallback({ strRoute: JSON.stringify(rprtVwrRoute) });
    }

    var _addAutoRefresh = function (s, e, timeout, rprtVwrRoute) {
        if (ASPxClientControl.GetControlCollection().GetByName('JobCardViewTileCbPanel') != null) {
            setInterval(() => {
                if (document.getElementById('JobCardViewTileCbPanel') != null && document.getElementById('JobCardViewTileCbPanel') != undefined) {
                    var rprtVwrCtrl = ASPxClientControl.GetControlCollection().GetByName('JobCardViewTileCbPanel');
                    if (rprtVwrCtrl != null && rprtVwrCtrl != undefined && rprtVwrRoute != null && rprtVwrRoute != undefined) {
                        DevExCtrl.LoadingPanel.Show(GlobalLoadingPanel);
                        var customerCtrl = ASPxClientControl.GetControlCollection().GetByName('Customer');
                        rprtVwrRoute.RecordId = customerCtrl.GetValue() || 0;

                        var destinationCtrl = ASPxClientControl.GetControlCollection().GetByName('DestinationByCustomerCbPanelforClosed');
                        if (destinationCtrl != null)
                            if (destinationCtrl.GetValue() != null && destinationCtrl.GetValue() != undefined) {
                                var dest = destinationCtrl.GetValue().split(',').map(String);//resetVal(destinationCtrl.GetValue(), checkListBoxDestinationByCustomerCbPanelforClosed);
                                var checkListBox = ASPxClientControl.GetControlCollection().GetByName('checkListBoxDestinationByCustomerCbPanelforClosed');
                                rprtVwrRoute.Location = [];
                                if (checkListBox != null && checkListBox != undefined)
                                    $.each(dest, function (key, value) {
                                        rprtVwrRoute.Location.push(_getValueByText(value, checkListBox));
                                    });
                                //rprtVwrRoute.Location = dest;
                            }
                        if (!ASPxClientControl.GetControlCollection().GetByName('JobCardViewTileCbPanel').InCallback()) {
                            rprtVwrCtrl.PerformCallback({ strRoute: JSON.stringify(rprtVwrRoute) });
                        }
                    }
                }
            }, timeout);
        }
    }

    var resetVal = function (input, listBoxCtrl) {
        var item = input.split(',').map(String);
        if (item.length == listBoxCtrl.GetItemCount()) {
            return ['ALL'];
        }
        else {
            return item;
        }
    }

    var resetProgramVal = function (input, listBoxCtrl) {
        var item = input.split(',').map(Number);
        if (item.length == listBoxCtrl.GetItemCount()) {
            return [0];
        }
        else {
            return item;
        }
    }

    return {
        GetVocReportByFilter: _getVocReportByFilter,
        DefaultSelectedLocation: _defaultSelectedLocation,
        PbsCheckBoxEventChange: _pbsCheckBoxEventChange,
        DefaultSelectedCustomer: _defaultSelectedCustomer,
        OnCardDataViewClick: _onCardDataViewClick,
        OnClickCardTileRefresh: _onClickCardTileRefresh,
        GetJobCardByFilter: _getJobCardByFilter
    }
})();

M4PLCommon.AdvancedReport = (function () {
    var _init = function () {
        $(".isAdditional").hide();
        $(".isDriverImport").hide();
        $(".isVisibleCapacityReport").hide();
        $(".isManifestReport").hide();
    }
    var _defaultSelectedCustomer = function (s, e) {
        s.SetSelectedIndex(0);
    }
    var _defaultSelectedProgram = function (s, e) {
        s.SetSelectedIndex(0);
    }
    var _defaultSelectedDestination = function (s, e) {
        s.SetSelectedIndex(0);
    }
    var _defaultSelectedOrigin = function (s, e) {
        s.SetSelectedIndex(0);
    }
    var _defaultSelectedServiceMode = function (s, e) {
        s.SetSelectedIndex(0);
    }
    var _defaultSelectedGatewayStatusId = function (s, e) {
        s.SetSelectedIndex(0);
    }
    var _closeGridLookup = function (s, e) {
        ProgramByCustomerCbPanelforClosed.ConfirmCurrentSelection();
        ProgramByCustomerCbPanelforClosed.HideDropDown();
        ProgramByCustomerCbPanelforClosed.Focus();
    }
    var textSeparator = ";";
    var _onListBoxSelectionChanged = function (s, e) {
        //if (args.index == 0)
        //    args.isSelected ? listBox.SelectAll() : listBox.UnselectAll();
        //UpdateSelectAllItem();
        //UpdateText();
    }
    var UpdateSelectAllItem = function () {
        IsAllSelected() ? checkListBox.SelectIndices([0]) : checkListBox.UnselectIndices([0]);
    }
    var IsAllSelected = function () {
        for (var i = 1; i < checkListBox.GetItemCount(); i++)
            if (!checkListBox.GetItem(i).selected)
                return false;
        return true;
    }
    var UpdateText = function () {
        var selectedItems = checkListBox.GetSelectedItems();
        ProgramCode.SetText(GetSelectedItemsText(selectedItems));
    }
    var _synchronizeListBoxValues = function (dropDown, args) {
        checkListBox.UnselectAll();
        var texts = dropDown.GetText().split(textSeparator);
        var values = GetValuesByTexts(texts);
        checkListBox.SelectValues(values);
        UpdateSelectAllItem();
        UpdateText();  // for remove non-existing texts
    }
    var GetSelectedItemsText = function (items) {
        var texts = [];
        for (var i = 0; i < items.length; i++)
            if (items[i].index != 0)
                texts.push(items[i].text);
        return texts.join(textSeparator);
    }
    var GetValuesByTexts = function (texts) {
        var actualValues = [];
        var item;
        for (var i = 0; i < texts.length; i++) {
            item = checkListBox.FindItemByText(texts[i]);
            if (item != null)
                actualValues.push(item.value);
        }
        return actualValues;
    }
    var _defaultDateTypeCustomer = function (s, e) {
        //s.SetSelectedIndex(0);
    }
    var _onBrokerInit = function (s, e) {
        var g = ProductTypeByCustomerCbPanelforClosed;
        var originClose = g.CloseDropDownByDocumentOrWindowEvent;
        g.CloseDropDownByDocumentOrWindowEvent = function (firstArg) {
            if (true)
                g.RollbackToLastConfirmedSelection();
            originClose.call(g, firstArg);
        }
    }
    var _productTypeOnSelectionChanged = function (s, e) {
        var pOneVal = s.GetRowKey(e.visibleIndex);
        if (pOneVal != null) {
            var grid = ProductTypeByCustomerCbPanelforClosed.GetGridView();
            if (e.isSelected && pOneVal != "ALL" && grid.IsRowSelectedOnPage(0)) {
                grid.UnselectRowOnPage(0);
            }
            else if (e.isSelected && pOneVal == "ALL" && s.GetSelectedRowCount() != 1) {
                grid.UnselectAllRowsOnPage();
                grid.SelectRowOnPage(0);
            }
        }
    }
    var _productTypeOnSelectionChanged = function (s, e) {
        var pOneVal = s.GetRowKey(e.visibleIndex);
        if (pOneVal != null) {
            var grid = ProductTypeByCustomerCbPanelforClosed.GetGridView();
            if (e.isSelected && pOneVal != "ALL" && grid.IsRowSelectedOnPage(0)) {
                grid.UnselectRowOnPage(0);
            }
            else if (e.isSelected && pOneVal == "ALL" && s.GetSelectedRowCount() != 1) {
                grid.UnselectAllRowsOnPage();
                grid.SelectRowOnPage(0);
            }
        }
    }
    var _brandOnSelectionChanged = function (s, e) {
        var pOneVal = s.GetRowKey(e.visibleIndex);
        if (pOneVal != null) {
            var grid = BrandByCustomerProgramCbPanelClosed.GetGridView();
            if (e.isSelected && pOneVal != "ALL" && grid.IsRowSelectedOnPage(0)) {
                grid.UnselectRowOnPage(0);
            }
            else if (e.isSelected && pOneVal == "ALL" && s.GetSelectedRowCount() != 1) {
                grid.UnselectAllRowsOnPage();
                grid.SelectRowOnPage(0);
            }
        }
    }
    var _destinationOnSelectionChanged = function (s, e) {
        var pOneVal = s.GetRowKey(e.visibleIndex);
        if (pOneVal != null) {
            var grid = DestinationByCustomerCbPanelforClosed.GetGridView();
            if (e.isSelected && pOneVal != "ALL" && grid.IsRowSelectedOnPage(0)) {
                grid.UnselectRowOnPage(0);
            }
            else if (e.isSelected && pOneVal == "ALL" && s.GetSelectedRowCount() != 1) {
                grid.UnselectAllRowsOnPage();
                grid.SelectRowOnPage(0);
            }
        }
    }
    var _gatewayStatusOnSelectionChanged = function (s, e) {
        var pOneVal = s.GetRowKey(e.visibleIndex);
        if (pOneVal != null) {
            var grid = GatewayStatusIdByCustomerProgramCbPanelClosed.GetGridView();
            if (e.isSelected && pOneVal != "ALL" && grid.IsRowSelectedOnPage(0)) {
                grid.UnselectRowOnPage(0);
            }
            else if (e.isSelected && pOneVal == "ALL" && s.GetSelectedRowCount() != 1) {
                grid.UnselectAllRowsOnPage();
                grid.SelectRowOnPage(0);
            }
        }
    }
    var _orginOnSelectionChanged = function (s, e) {
        var pOneVal = s.GetRowKey(e.visibleIndex);
        if (pOneVal != null) {
            var grid = OriginByCustomerCbPanelforClosed.GetGridView();
            if (e.isSelected && pOneVal != "ALL" && grid.IsRowSelectedOnPage(0)) {
                grid.UnselectRowOnPage(0);
            }
            else if (e.isSelected && pOneVal == "ALL" && s.GetSelectedRowCount() != 1) {
                grid.UnselectAllRowsOnPage();
                grid.SelectRowOnPage(0);
            }
        }
    }
    var _programOnSelectionChanged = function (s, e) {
        var pOneVal = s.GetRowKey(e.visibleIndex);
        if (pOneVal != null) {
            var grid = ProgramByCustomerCbPanelforClosed.GetGridView();
            if (e.isSelected && pOneVal != "0" && grid.IsRowSelectedOnPage(0)) {
                grid.UnselectRowOnPage(0);
            }
            else if (e.isSelected && pOneVal == "0" && s.GetSelectedRowCount() != 1) {
                grid.UnselectAllRowsOnPage();
                grid.SelectRowOnPage(0);
            }
        }
    }
    var _serviceModeOnSelectionChanged = function (s, e) {
        var pOneVal = s.GetRowKey(e.visibleIndex);
        if (pOneVal != null) {
            var grid = ServiceModeByCustomerCbPanelforClosed.GetGridView();
            if (e.isSelected && pOneVal != "ALL" && grid.IsRowSelectedOnPage(0)) {
                grid.UnselectRowOnPage(0);
            }
            else if (e.isSelected && pOneVal == "ALL" && s.GetSelectedRowCount() != 1) {
                grid.UnselectAllRowsOnPage();
                grid.SelectRowOnPage(0);
            }
        }
    }
    var _channelOnSelectionChanged = function (s, e) {
        var pOneVal = s.GetRowKey(e.visibleIndex);
        if (pOneVal != null) {
            var grid = JobChannelByProgramCustomerCbPanelforClosed.GetGridView();
            if (e.isSelected && pOneVal != "ALL" && grid.IsRowSelectedOnPage(0)) {
                grid.UnselectRowOnPage(0);
            }
            else if (e.isSelected && pOneVal == "ALL" && s.GetSelectedRowCount() != 1) {
                grid.UnselectAllRowsOnPage();
                grid.SelectRowOnPage(0);
            }
        }
    }
    var _dateType_OnClickViewSelected = function (s, e) {
        s.GetRowValues(s.GetFocusedRowIndex(), "DateTypeName", M4PLCommon.AdvancedReport.GetSelectedFieldValuesCallbackSinble);
    }
    var _jobStatus_OnClickViewSelected = function (s, e) {
        s.GetRowValues(s.GetFocusedRowIndex(), "JobStatusIdName", M4PLCommon.AdvancedReport.GetSelectedFieldValuesCallbackSinble);
    }
    var _orderType_OnClickViewSelected = function (s, e) {
        s.GetRowValues(s.GetFocusedRowIndex(), "OrderTypeName", M4PLCommon.AdvancedReport.GetSelectedFieldValuesCallbackSinble);
    }
    var _schedule_OnClickViewSelected = function (s, e) {
        s.GetRowValues(s.GetFocusedRowIndex(), "ScheduledName", M4PLCommon.AdvancedReport.GetSelectedFieldValuesCallbackSinble);
    }
    var _getSelectedFieldValuesCallbackSinble = function (values) {
        return values;
    }

    function priceCostReload(s, e, rprtVwrCtrl, rprtVwrRoute) {
        if ($('.errorMessages') != undefined) {
            $('.errorMessages').html('');
        }
        var reportTypeCtrl = ASPxClientControl.GetControlCollection().GetByName('ReportType');
        var customerCtrl = ASPxClientControl.GetControlCollection().GetByName('Customer');
        var programCtrl = ASPxClientControl.GetControlCollection().GetByName('ProgramByCustomerCbPanelforClosed');
        var originCtrl = ASPxClientControl.GetControlCollection().GetByName('OriginByCustomerCbPanelforClosed');
        var destinationCtrl = ASPxClientControl.GetControlCollection().GetByName('DestinationByCustomerCbPanelforClosed');
        var brandCtrl = ASPxClientControl.GetControlCollection().GetByName('BrandByCustomerProgramCbPanelClosed');
        var serviceModeCtrl = ASPxClientControl.GetControlCollection().GetByName('ServiceModeByCustomerCbPanelforClosed');
        var productTypeCtrl = ASPxClientControl.GetControlCollection().GetByName('ProductTypeByCustomerCbPanelforClosed');
        var startDateCtrl = ASPxClientControl.GetControlCollection().GetByName('StartDate');
        var endDateCtrl = ASPxClientControl.GetControlCollection().GetByName('EndDate');
        var jobChannelCtrl = ASPxClientControl.GetControlCollection().GetByName('JobChannelByProgramCustomerCbPanelforClosed');
        var dateTypeCtrl = ASPxClientControl.GetControlCollection().GetByName('DateTypeByCustomerProgramCbPanelClosed');

        rprtVwrRoute.ReportType = reportTypeCtrl.GetValue();
        rprtVwrRoute.CustomerId = customerCtrl.GetValue();
        rprtVwrRoute.FileName = reportTypeCtrl.GetText();

        if (programCtrl != null) {
            if (programCtrl.GetValue() != null && programCtrl != undefined && programCtrl.GetValue() != "ALL") {
                var programCheckCtrl = ASPxClientControl.GetControlCollection().GetByName('checkListBoxProgramByCustomerCbPanelforClosed');
                if (programCheckCtrl != null) {
                    var selctedItems = programCheckCtrl.GetSelectedItems();
                    var item = [];
                    for (var i = 0; i < selctedItems.length; i++) {
                        item.push(parseInt(selctedItems[i].value));
                    }
                    rprtVwrRoute.ProgramId = item;
                }
            }
        }

        if (originCtrl != null)
            if (originCtrl.GetValue() != null && originCtrl.GetValue() != undefined)
                rprtVwrRoute.Origin = originCtrl.GetValue().split(',').map(String);//resetVal(originCtrl.GetValue(), checkListBoxOriginByCustomerCbPanelforClosed);
        if (destinationCtrl != null)
            if (destinationCtrl.GetValue() != null && destinationCtrl.GetValue() != undefined)
                rprtVwrRoute.Destination = destinationCtrl.GetValue().split(',').map(String);//resetVal(destinationCtrl.GetValue(), checkListBoxDestinationByCustomerCbPanelforClosed);
        if (brandCtrl != null)
            if (brandCtrl.GetValue() != null && brandCtrl.GetValue() != undefined)
                rprtVwrRoute.Brand = brandCtrl.GetValue().split(',').map(String);//resetVal(brandCtrl.GetValue(), checkListBoxBrandByCustomerProgramCbPanelClosed);
        if (serviceModeCtrl != null)
            if (serviceModeCtrl.GetValue() != null && serviceModeCtrl.GetValue() != undefined)
                rprtVwrRoute.ServiceMode = serviceModeCtrl.GetValue().split(',').map(String);//resetVal(serviceModeCtrl.GetValue(), checkListBoxServiceModeByCustomerCbPanelforClosed);
        if (productTypeCtrl != null)
            if (productTypeCtrl.GetValue() != null && productTypeCtrl.GetValue() != undefined)
                rprtVwrRoute.ProductType = productTypeCtrl.GetValue().split(',').map(String);//resetVal(productTypeCtrl.GetValue(), checkListBoxProductTypeByCustomerCbPanelforClosed);

        if (dateTypeCtrl != null)
            rprtVwrRoute.DateTypeName = dateTypeCtrl.GetText();

        if (jobChannelCtrl != null)
            if (jobChannelCtrl.GetValue() != null && jobChannelCtrl.GetValue() != undefined)
                rprtVwrRoute.Channel = jobChannelCtrl.GetValue().split(',').map(String);

        var startDate = startDateCtrl.GetValue();
        var endDate = endDateCtrl.GetValue();
        if (startDate != undefined && endDate != undefined && startDate != null && endDate != null) {
            rprtVwrRoute.StartDate = startDate.getFullYear() + '-' + (startDate.getMonth() + 1) + '-' + startDate.getDate();
            rprtVwrRoute.EndDate = endDate.getFullYear() + '-' + (endDate.getMonth() + 1) + '-' + endDate.getDate();
        }
        rprtVwrRoute.IsFormRequest = true;

        var IsFormValidate = true;
        if ((startDateCtrl.GetValue() != "" && endDateCtrl.GetValue() != "" && startDateCtrl.GetValue() != null && endDateCtrl.GetValue() != null) && new Date(startDateCtrl.GetValue()) > new Date(endDateCtrl.GetValue())) {
            if ($('.errorMessages') != undefined) {
                $('.errorMessages').append('<p>* End date should be greater than start date.</p>');
            }
            IsFormValidate = false;
        }
        return IsFormValidate;
    }
    var _getJobAdvanceReportByFilter = function (s, e, rprtVwrCtrl, rprtVwrRoute) {
        var reportTypeCtrl = ASPxClientControl.GetControlCollection().GetByName('ReportType');
        var gridCtrl = ASPxClientControl.GetControlCollection().GetByName('JobAdvanceReportGridView');
        if (gridCtrl != null && gridCtrl != undefined) {
            rprtVwrCtrl = gridCtrl;
        }
        if (reportTypeCtrl != null &&
            ((reportTypeCtrl.GetText() == "Driver Scrub Report")
                || (reportTypeCtrl.GetText() == "Capacity Report")
                || (reportTypeCtrl.GetText() == "Pride Metric Report"))) {
            var customerCtrl = ASPxClientControl.GetControlCollection().GetByName('Customer');
            if (reportTypeCtrl.GetText() == "Driver Scrub Report" || (reportTypeCtrl.GetText() == "Pride Metric Report")) {
                var startDateCtrl = ASPxClientControl.GetControlCollection().GetByName('StartDate');
                var endDateCtrl = ASPxClientControl.GetControlCollection().GetByName('EndDate');
                var startDate = startDateCtrl.GetValue();
                var endDate = endDateCtrl.GetValue();
                if (startDate != undefined && endDate != undefined && startDate != null && endDate != null) {
                    rprtVwrRoute.StartDate = startDate.getFullYear() + '-' + (startDate.getMonth() + 1) + '-' + startDate.getDate();
                    rprtVwrRoute.EndDate = endDate.getFullYear() + '-' + (endDate.getMonth() + 1) + '-' + endDate.getDate();
                }
            }
            if (reportTypeCtrl.GetText() == "Capacity Report") {
                var yearCtrl = ASPxClientControl.GetControlCollection().GetByName('Year');
                rprtVwrRoute.ProjectedYear = yearCtrl.GetText() != null ? parseInt(yearCtrl.GetText()) : yearCtrl.GetText();
            }
            rprtVwrRoute.ReportType = reportTypeCtrl.GetValue();
            rprtVwrRoute.CustomerId = customerCtrl.GetValue();

            rprtVwrRoute.IsFormRequest = true;
            rprtVwrRoute.FileName = reportTypeCtrl.GetText();
            $(".isDriverScrubreport").show();
            $(".isDriverbtnScrubreport").show();
            rprtVwrCtrl.PerformCallback({ strRoute: JSON.stringify(rprtVwrRoute) });
        }
        else if (reportTypeCtrl != null && (reportTypeCtrl.GetText() == "Price Charge" || reportTypeCtrl.GetText() == "Cost Charge")) {
            if (priceCostReload(s, e, rprtVwrCtrl, rprtVwrRoute)) {
                rprtVwrCtrl.PerformCallback({ strRoute: JSON.stringify(rprtVwrRoute) });
            }
        }
        else {
            if (reloadresult(s, e, rprtVwrCtrl, rprtVwrRoute)) {
                rprtVwrCtrl.PerformCallback({ strRoute: JSON.stringify(rprtVwrRoute) });
            }
        }
    }
    var _reportTypeChangeEvent = function (s, e, rprtVwrCtrl, rprtVwrRoute) {
        $(".isVisibleCapacityReport").hide();
        $(".isDriverImport").hide();
        var startDateCtrl = ASPxClientControl.GetControlCollection().GetByName('StartDate');
        var endDateCtrl = ASPxClientControl.GetControlCollection().GetByName('EndDate');
        var reportTypeCtrl = ASPxClientControl.GetControlCollection().GetByName('ReportType');
        //startDateCtrl.SetValue(null);
        //endDateCtrl.SetValue(null);
        //if (reportTypeCtrl != null &&
        //    reportTypeCtrl.GetText() != "Job Advance Report" && reportTypeCtrl.GetText() != "Manifest Report" && reportTypeCtrl.GetText() != "OSD Report") {
        //    var today = new Date();
        //    var yeasterday = new Date();
        //    yeasterday.setDate(yeasterday.getDate() - 1);
        //    startDateCtrl.SetValue(yeasterday);
        //    endDateCtrl.SetValue(today);
        //} else {
        //    startDateCtrl.SetValue(null);
        //    endDateCtrl.SetValue(null);
        //}
        if (reportTypeCtrl != null && reportTypeCtrl.GetText() == "Manifest Report") {
            $(".isManifestReport").show();
        } else {
            $(".isManifestReport").hide();
        }
        if (reportTypeCtrl != null &&
            ((reportTypeCtrl.GetText() == "Driver Scrub Report"))
            || (reportTypeCtrl.GetText() == "Capacity Report")
            || (reportTypeCtrl.GetText() == "Pride Metric Report")) {
            controlEnabledDisabled(false);
            if (reportTypeCtrl.GetText() == "Capacity Report") {
                startDateCtrl.SetEnabled(false);
                endDateCtrl.SetEnabled(false);
                $(".isVisibleCapacityReport").show();
            } else {
                startDateCtrl.SetEnabled(true);
                endDateCtrl.SetEnabled(true);
                $(".isVisibleCapacityReport").hide();
            }

            if ((reportTypeCtrl.GetText() != "Pride Metric Report")) {
                $(".isDriverScrubreport").hide();
                $(".isDriverbtnScrubreport").hide();
            } else {
                $(".isDriverScrubreport").show();
                $(".isDriverbtnScrubreport").show();
                rprtVwrRoute.IsFormRequest = true;
                rprtVwrRoute.ReportType = reportTypeCtrl.GetValue();
                //rprtVwrCtrl.PerformCallback({ strRoute: JSON.stringify(rprtVwrRoute) });
            }
            var customerCtrl = ASPxClientControl.GetControlCollection().GetByName('Customer');
            customerCtrl.SetValue(0);
        }
        else if (reportTypeCtrl != null && (reportTypeCtrl.GetText() == "Price Charge" || reportTypeCtrl.GetText() == "Cost Charge")) {
            startDateCtrl.SetEnabled(true);
            endDateCtrl.SetEnabled(true);
            $(".isManifestReport").hide();
            $(".isVisibleCapacityReport").hide();
            $(".isDriverScrubreport").show();
            $(".isDriverbtnScrubreport").show();
            var gatewayCtrl = ASPxClientControl.GetControlCollection().GetByName('GatewayStatusIdByCustomerProgramCbPanelClosed');
            var scheduleTypeCtrl = ASPxClientControl.GetControlCollection().GetByName('ScheduleByCustomerProgramCbPanelClosed');
            var orderTypeCtrl = ASPxClientControl.GetControlCollection().GetByName('OrderTypeByCustomerProgramCbPanelClosed');
            var jobStatusCtrl = ASPxClientControl.GetControlCollection().GetByName('JobStatusIdByCustomerProgramCbPanelClosed');
            var searchCtrl = ASPxClientControl.GetControlCollection().GetByName('Search');
            gatewayCtrl.SetEnabled(false);
            scheduleTypeCtrl.SetEnabled(false);
            orderTypeCtrl.SetEnabled(false);
            jobStatusCtrl.SetEnabled(false);
            searchCtrl.SetEnabled(false);

            jobStatusCtrl.GetInputElement().style.backgroundColor = "#9BEBF2";
            orderTypeCtrl.GetInputElement().style.backgroundColor = "#9BEBF2";
            scheduleTypeCtrl.GetInputElement().style.backgroundColor = "#9BEBF2";
            rprtVwrRoute.IsFormRequest = true;
            rprtVwrRoute.ReportType = reportTypeCtrl.GetValue();
            //rprtVwrCtrl.PerformCallback({ strRoute: JSON.stringify(rprtVwrRoute) });
        }
        else {
            controlEnabledDisabled(true);
            startDateCtrl.SetEnabled(true);
            endDateCtrl.SetEnabled(true);
            if (reportTypeCtrl.GetText() == "Manifest Report") {
                $(".isManifestReport").show();
            } else {
                $(".isManifestReport").hide();
            }
            $(".isVisibleCapacityReport").hide();
            $(".isDriverScrubreport").show();
            $(".isDriverbtnScrubreport").show();
            if (reloadresult(s, e, rprtVwrCtrl, rprtVwrRoute)) {
                //rprtVwrCtrl.PerformCallback({ strRoute: JSON.stringify(rprtVwrRoute) });
            }
        }
    }

    function reloadresult(s, e, rprtVwrCtrl, rprtVwrRoute) {
        if ($('.errorMessages') != undefined) {
            $('.errorMessages').html('');
        }
        var reportTypeCtrl = ASPxClientControl.GetControlCollection().GetByName('ReportType');
        var customerCtrl = ASPxClientControl.GetControlCollection().GetByName('Customer');
        var programCtrl = ASPxClientControl.GetControlCollection().GetByName('ProgramByCustomerCbPanelforClosed');
        var originCtrl = ASPxClientControl.GetControlCollection().GetByName('OriginByCustomerCbPanelforClosed');
        var destinationCtrl = ASPxClientControl.GetControlCollection().GetByName('DestinationByCustomerCbPanelforClosed');
        var brandCtrl = ASPxClientControl.GetControlCollection().GetByName('BrandByCustomerProgramCbPanelClosed');
        var gatewayCtrl = ASPxClientControl.GetControlCollection().GetByName('GatewayStatusIdByCustomerProgramCbPanelClosed');
        var serviceModeCtrl = ASPxClientControl.GetControlCollection().GetByName('ServiceModeByCustomerCbPanelforClosed');
        var productTypeCtrl = ASPxClientControl.GetControlCollection().GetByName('ProductTypeByCustomerCbPanelforClosed');
        var scheduleTypeCtrl = ASPxClientControl.GetControlCollection().GetByName('ScheduleByCustomerProgramCbPanelClosed');
        var orderTypeCtrl = ASPxClientControl.GetControlCollection().GetByName('OrderTypeByCustomerProgramCbPanelClosed');
        var startDateCtrl = ASPxClientControl.GetControlCollection().GetByName('StartDate');
        var endDateCtrl = ASPxClientControl.GetControlCollection().GetByName('EndDate');
        var jobChannelCtrl = ASPxClientControl.GetControlCollection().GetByName('JobChannelByProgramCustomerCbPanelforClosed');
        var jobStatusCtrl = ASPxClientControl.GetControlCollection().GetByName('JobStatusIdByCustomerProgramCbPanelClosed');
        var dateTypeCtrl = ASPxClientControl.GetControlCollection().GetByName('DateTypeByCustomerProgramCbPanelClosed');
        var searchCtrl = ASPxClientControl.GetControlCollection().GetByName('Search');
        var packagingTypeCtrl = ASPxClientControl.GetControlCollection().GetByName('PackagingTypeByJobCbPanelClosed');
        var cargoTitleCtrl = ASPxClientControl.GetControlCollection().GetByName('CargoId');

        rprtVwrRoute.ReportType = reportTypeCtrl.GetValue();
        rprtVwrRoute.CustomerId = customerCtrl.GetValue();
        rprtVwrRoute.FileName = reportTypeCtrl.GetText();

        if (programCtrl != null) {
            if (programCtrl.GetValue() != null && programCtrl != undefined && programCtrl.GetValue() != "ALL") {
                var programCheckCtrl = ASPxClientControl.GetControlCollection().GetByName('checkListBoxProgramByCustomerCbPanelforClosed');
                if (programCheckCtrl != null) {
                    var selctedItems = programCheckCtrl.GetSelectedItems();
                    var item = [];
                    for (var i = 0; i < selctedItems.length; i++) {
                        item.push(parseInt(selctedItems[i].value));
                    }
                    rprtVwrRoute.ProgramId = item;
                }
            }
        }

        if (originCtrl != null)
            if (originCtrl.GetValue() != null && originCtrl.GetValue() != undefined)
                rprtVwrRoute.Origin = originCtrl.GetValue().split(',').map(String);
        if (destinationCtrl != null)
            if (destinationCtrl.GetValue() != null && destinationCtrl.GetValue() != undefined)
                rprtVwrRoute.Destination = destinationCtrl.GetValue().split(',').map(String);
        if (brandCtrl != null)
            if (brandCtrl.GetValue() != null && brandCtrl.GetValue() != undefined)
                rprtVwrRoute.Brand = brandCtrl.GetValue().split(',').map(String);
        if (gatewayCtrl != null)
            if (gatewayCtrl.GetValue() != null && gatewayCtrl.GetValue() != undefined)
                rprtVwrRoute.GatewayTitle = gatewayCtrl.GetValue().split(',').map(String);
        if (serviceModeCtrl != null)
            if (serviceModeCtrl.GetValue() != null && serviceModeCtrl.GetValue() != undefined)
                rprtVwrRoute.ServiceMode = serviceModeCtrl.GetValue().split(',').map(String);
        if (productTypeCtrl != null)
            if (productTypeCtrl.GetValue() != null && productTypeCtrl.GetValue() != undefined)
                rprtVwrRoute.ProductType = productTypeCtrl.GetValue().split(',').map(String);

        if (dateTypeCtrl != null)
            rprtVwrRoute.DateTypeName = dateTypeCtrl.GetText();

        if (scheduleTypeCtrl != null)
            rprtVwrRoute.Scheduled = scheduleTypeCtrl.GetText();
        if (orderTypeCtrl != null)
            rprtVwrRoute.OrderType = orderTypeCtrl.GetText();
        if (jobChannelCtrl != null)
            if (jobChannelCtrl.GetValue() != null && jobChannelCtrl.GetValue() != undefined)
                rprtVwrRoute.Channel = jobChannelCtrl.GetValue().split(',').map(String);

        if (jobStatusCtrl != null)
            rprtVwrRoute.JobStatus = jobStatusCtrl.GetText();
        if (searchCtrl != null)
            rprtVwrRoute.Search = searchCtrl.GetValue();
        var startDate = startDateCtrl.GetValue();
        if (startDate != null)
            rprtVwrRoute.StartDate = startDate.getFullYear() + '-' + (startDate.getMonth() + 1) + '-' + startDate.getDate();
        var endDate = endDateCtrl.GetValue();
        if (endDate != null)
            rprtVwrRoute.EndDate = endDate.getFullYear() + '-' + (endDate.getMonth() + 1) + '-' + endDate.getDate();
        rprtVwrRoute.IsFormRequest = true;
        if (packagingTypeCtrl != null)
            rprtVwrRoute.PackagingCode = packagingTypeCtrl.GetText();
        if (cargoTitleCtrl != null)
            rprtVwrRoute.CargoId = cargoTitleCtrl.GetValue();
        var IsFormValidate = true;
        if ((startDateCtrl.GetValue() != "" && endDateCtrl.GetValue() != "" && startDateCtrl.GetValue() != null && endDateCtrl.GetValue() != null) && new Date(startDateCtrl.GetValue()) > new Date(endDateCtrl.GetValue())) {
            if ($('.errorMessages') != undefined) {
                $('.errorMessages').append('<p>* End date should be greater than start date.</p>');
            }
            IsFormValidate = false;
        }
        return IsFormValidate;
    }
    function controlEnabledDisabled(isEnabled) {
        var prgmCtrl = ASPxClientControl.GetControlCollection().GetByName('ProgramByCustomerCbPanelforClosed');
        var originCtrl = ASPxClientControl.GetControlCollection().GetByName('OriginByCustomerCbPanelforClosed');
        var destinationCtrl = ASPxClientControl.GetControlCollection().GetByName('DestinationByCustomerCbPanelforClosed');
        var brandCtrl = ASPxClientControl.GetControlCollection().GetByName('BrandByCustomerProgramCbPanelClosed');
        var gatewayCtrl = ASPxClientControl.GetControlCollection().GetByName('GatewayStatusIdByCustomerProgramCbPanelClosed');
        var serviceModeCtrl = ASPxClientControl.GetControlCollection().GetByName('ServiceModeByCustomerCbPanelforClosed');
        var productTypeCtrl = ASPxClientControl.GetControlCollection().GetByName('ProductTypeByCustomerCbPanelforClosed');
        var scheduleTypeCtrl = ASPxClientControl.GetControlCollection().GetByName('ScheduleByCustomerProgramCbPanelClosed');
        var orderTypeCtrl = ASPxClientControl.GetControlCollection().GetByName('OrderTypeByCustomerProgramCbPanelClosed');
        var jobChannelCtrl = ASPxClientControl.GetControlCollection().GetByName('JobChannelByProgramCustomerCbPanelforClosed');
        var jobStatusCtrl = ASPxClientControl.GetControlCollection().GetByName('JobStatusIdByCustomerProgramCbPanelClosed');
        var dateTypeCtrl = ASPxClientControl.GetControlCollection().GetByName('DateTypeByCustomerProgramCbPanelClosed');
        var searchCtrl = ASPxClientControl.GetControlCollection().GetByName('Search');

        prgmCtrl.SetEnabled(isEnabled);
        originCtrl.SetEnabled(isEnabled);
        destinationCtrl.SetEnabled(isEnabled);
        brandCtrl.SetEnabled(isEnabled);
        gatewayCtrl.SetEnabled(isEnabled);
        serviceModeCtrl.SetEnabled(isEnabled);
        productTypeCtrl.SetEnabled(isEnabled);
        jobChannelCtrl.SetEnabled(isEnabled);
        searchCtrl.SetEnabled(isEnabled);

        jobStatusCtrl.SetEnabled(isEnabled);
        dateTypeCtrl.SetEnabled(isEnabled);
        scheduleTypeCtrl.SetEnabled(isEnabled);
        orderTypeCtrl.SetEnabled(isEnabled);

        var bgColor = !isEnabled ? "#9BEBF2" : '#fff';
        dateTypeCtrl.GetInputElement().style.backgroundColor = bgColor;
        jobStatusCtrl.GetInputElement().style.backgroundColor = bgColor;
        orderTypeCtrl.GetInputElement().style.backgroundColor = bgColor;
        scheduleTypeCtrl.GetInputElement().style.backgroundColor = bgColor;
    }
    var _importDriverScrub = function (s, e, rprtVwrCtrl, rprtVwrRoute) {
        rprtVwrRoute.Action = "FormView";
        rprtVwrRoute.OwnerCbPanel = "JobAdvanceReportCbPanel";
        rprtVwrRoute.IsPopup = true;
        var customerCtrl = ASPxClientControl.GetControlCollection().GetByName('Customer');
        var reportTypeCtrl = ASPxClientControl.GetControlCollection().GetByName('ReportType');
        if (customerCtrl != null)
            rprtVwrRoute.RecordId = customerCtrl.GetValue() != null && customerCtrl.GetValue() > 0
                ? parseInt(customerCtrl.GetValue()) : 0;
        if (reportTypeCtrl != null) {
            rprtVwrRoute.ParentRecordId = reportTypeCtrl.GetValue() != null && reportTypeCtrl.GetValue() > 0
                ? parseInt(reportTypeCtrl.GetValue()) : 0;
            rprtVwrRoute.Location = [];
            rprtVwrRoute.Location.push(reportTypeCtrl.GetText());
        }
        RecordPopupControl.PerformCallback({ strRoute: JSON.stringify(rprtVwrRoute) });
    }
    return {
        Init: _init,
        DefaultSelectedCustomer: _defaultSelectedCustomer,
        DefaultSelectedProgram: _defaultSelectedProgram,
        DefaultSelectedDestination: _defaultSelectedDestination,
        DefaultSelectedOrigin: _defaultSelectedOrigin,
        DefaultSelectedServiceMode: _defaultSelectedServiceMode,
        DefaultSelectedGatewayStatusId: _defaultSelectedGatewayStatusId,
        CloseGridLookup: _closeGridLookup,
        OnListBoxSelectionChanged: _onListBoxSelectionChanged,
        SynchronizeListBoxValues: _synchronizeListBoxValues,
        DefaultDateTypeCustomer: _defaultDateTypeCustomer,
        ProductTypeOnSelectionChanged: _productTypeOnSelectionChanged,
        BrandOnSelectionChanged: _brandOnSelectionChanged,
        DestinationOnSelectionChanged: _destinationOnSelectionChanged,
        GatewayStatusOnSelectionChanged: _gatewayStatusOnSelectionChanged,
        OrginOnSelectionChanged: _orginOnSelectionChanged,
        ProgramOnSelectionChanged: _programOnSelectionChanged,
        ServiceModeOnSelectionChanged: _serviceModeOnSelectionChanged,
        ChannelOnSelectionChanged: _channelOnSelectionChanged,
        DateType_OnClickViewSelected: _dateType_OnClickViewSelected,
        GetSelectedFieldValuesCallbackSinble: _getSelectedFieldValuesCallbackSinble,
        JobStatus_OnClickViewSelected: _jobStatus_OnClickViewSelected,
        OrderType_OnClickViewSelected: _orderType_OnClickViewSelected,
        Schedule_OnClickViewSelected: _schedule_OnClickViewSelected,
        GetJobAdvanceReportByFilter: _getJobAdvanceReportByFilter,
        ReportTypeChangeEvent: _reportTypeChangeEvent,
        ImportDriverScrub: _importDriverScrub
    }
})();

M4PLCommon.ProgramRollUp = (function () {
    var _disableProgramRollUpBillingJob = function (s, e) {
        var prgRollUpBillingCtrl = ASPxClientControl.GetControlCollection().GetByName('PrgRollUpBilling');

        if (prgRollUpBillingCtrl != null && prgRollUpBillingCtrl != undefined) {
            var prgRollUpBillingJobCtrl = ASPxClientControl.GetControlCollection().GetByName('PrgRollUpBillingJobFieldId');
            if (prgRollUpBillingJobCtrl != null) {
                prgRollUpBillingJobCtrl.SetVisible(prgRollUpBillingCtrl.GetChecked());
            }
        }
    };

    var _isEnableProgramRollUpBillingJob = function (s, e) {
        var prgRollUpBillingJobCtrl = ASPxClientControl.GetControlCollection().GetByName('PrgRollUpBillingJobFieldId');
        if (prgRollUpBillingJobCtrl != null) {
            prgRollUpBillingJobCtrl.SetVisible(s.GetChecked());
        }
    };

    return {
        EnableProgramRollUpBillingJob: _isEnableProgramRollUpBillingJob,
        DisableProgramRollUpBillingJob: _disableProgramRollUpBillingJob
    }
})();

M4PLCommon.DropDownMultiSelect = (function () {
    var textSeparator = ",";
    //-------Location------------------
    var _updateTextLocation = function () {
        var checkListBox = ASPxClientControl.GetControlCollection().GetByName('checkListBoxCustomerLocationCbPanelClosed');
        if (checkListBox != null) {
            var selectedItems = checkListBox.GetSelectedItems();
            CustomerLocationCbPanelClosed.SetText(_getSelectedItemsText(selectedItems, checkListBox));
        }
    }
    var _updateTextLocationDefault = function () {
        var checkListBox = ASPxClientControl.GetControlCollection().GetByName('checkListBoxCustomerLocationCbPanelClosed');
        if (checkListBox != null) {
            if (ASPxClientControl.GetControlCollection().GetByName('Customer') != null
                && ASPxClientControl.GetControlCollection().GetByName('Customer').GetValue() >= 0) {
                checkListBox.SelectAll();
            }
            var selectedItems = checkListBox.GetSelectedItems();
            CustomerLocationCbPanelClosed.SetText(_getSelectedItemsText(selectedItems, checkListBox));
        }
    }
    var _synchronizeListBoxValuesLocation = function (dropDown, args) {
        var checkListBox = ASPxClientControl.GetControlCollection().GetByName('checkListBoxCustomerLocationCbPanelClosed');
        //checkListBox.UnselectAll();
        var texts = dropDown.GetText().split(textSeparator);
        var values = _getValuesByTexts(texts, checkListBox);
        checkListBox.SelectValues(values);
        _updateTextBrand();//dropDown.name); // for remove non-existing texts
    }

    //-------Brand------------------
    var _updateTextBrand = function () {
        var checkListBox = ASPxClientControl.GetControlCollection().GetByName('checkListBoxBrandByCustomerProgramCbPanelClosed');
        if (checkListBox != null) {
            var selectedItems = checkListBox.GetSelectedItems();
            BrandByCustomerProgramCbPanelClosed.SetText(_getSelectedItemsText(selectedItems, checkListBox));
        }
    }
    var _updateTextBrandDefault = function () {
        var checkListBox = ASPxClientControl.GetControlCollection().GetByName('checkListBoxBrandByCustomerProgramCbPanelClosed');
        if (checkListBox != null) {
            if (ASPxClientControl.GetControlCollection().GetByName('Customer') != null
                && ASPxClientControl.GetControlCollection().GetByName('Customer').GetValue() >= 0) {
                checkListBox.SelectAll();
            }
            var selectedItems = checkListBox.GetSelectedItems();
            BrandByCustomerProgramCbPanelClosed.SetText(_getSelectedItemsText(selectedItems, checkListBox));
        }
    }
    var _synchronizeListBoxValuesBrand = function (dropDown, args) {
        var checkListBox = ASPxClientControl.GetControlCollection().GetByName('checkListBoxBrandByCustomerProgramCbPanelClosed');
        //checkListBox.UnselectAll();
        var texts = dropDown.GetText().split(textSeparator);
        var values = _getValuesByTexts(texts, checkListBox);
        checkListBox.SelectValues(values);
        _updateTextBrand();//dropDown.name); // for remove non-existing texts
    }

    //-------Destination Job Card------------------
    var _updateValueDestination = function () {
        var checkListBox = ASPxClientControl.GetControlCollection().GetByName('checkListBoxDestinationByCustomerCbPanelforClosed');
        if (checkListBox != null) {
            var selectedItems = checkListBox.GetSelectedItems();
            DestinationByCustomerCbPanelforClosed.SetText(_getSelectedItemsVal(selectedItems, checkListBox));
        }
    }

    var _updateValueDestinationDefault = function (s, e, selectedLocation) {
        var checkListBox = ASPxClientControl.GetControlCollection().GetByName('checkListBoxDestinationByCustomerCbPanelforClosed');
        if (checkListBox != null) {
            if ((ASPxClientControl.GetControlCollection().GetByName('Customer') != null
                && ASPxClientControl.GetControlCollection().GetByName('Customer').GetValue() >= 0) ||
                (ASPxClientControl.GetControlCollection().GetByName('DestinationByCustomerCbPanelforClosed') != null
                    && ASPxClientControl.GetControlCollection().GetByName('DestinationByCustomerCbPanelforClosed').GetValue() == null)) {
                if (selectedLocation !== null && selectedLocation !== undefined && selectedLocation.length > 0 && selectedLocation[0] != 'ALL') {
                    checkListBox.SelectValues(selectedLocation);
                }
                else
                    checkListBox.SelectAll();
            }
            var selectedItems = checkListBox.GetSelectedItems();
            if (selectedItems && selectedItems.length == 0) {
                checkListBox.SelectAll();
                selectedItems = checkListBox.GetSelectedItems();
            }

            DestinationByCustomerCbPanelforClosed.SetText(_getSelectedItemsVal(selectedItems, checkListBox));
        }
    }
    var _synchronizeListBoxValuesDestinationValue = function (dropDown, args) {
        var checkListBox = ASPxClientControl.GetControlCollection().GetByName('checkListBoxDestinationByCustomerCbPanelforClosed');
        //checkListBox.UnselectAll();
        var texts = dropDown.GetText().split(textSeparator);
        var values = _getValuesByTexts(texts, checkListBox);
        checkListBox.SelectValues(values);
        _updateValueDestination();//dropDown.name); // for remove non-existing texts
    }

    //-------Destination Job Advance report------------------
    var _updateTextDestination = function () {
        var checkListBox = ASPxClientControl.GetControlCollection().GetByName('checkListBoxDestinationByCustomerCbPanelforClosed');
        if (checkListBox != null) {
            var selectedItems = checkListBox.GetSelectedItems();
            DestinationByCustomerCbPanelforClosed.SetText(_getSelectedItemsText(selectedItems, checkListBox));
        }
    }

    var _updateTextDestinationDefault = function (s, e, selectedLocation) {
        var checkListBox = ASPxClientControl.GetControlCollection().GetByName('checkListBoxDestinationByCustomerCbPanelforClosed');
        if (checkListBox != null) {
            if ((ASPxClientControl.GetControlCollection().GetByName('Customer') != null
                && ASPxClientControl.GetControlCollection().GetByName('Customer').GetValue() >= 0) ||
                (ASPxClientControl.GetControlCollection().GetByName('DestinationByCustomerCbPanelforClosed') != null
                    && ASPxClientControl.GetControlCollection().GetByName('DestinationByCustomerCbPanelforClosed').GetValue() == null)) {
                if (selectedLocation !== null && selectedLocation !== undefined && selectedLocation.length > 0 && selectedLocation[0] != 'ALL') {
                    checkListBox.SelectValues(selectedLocation);
                }
                else
                    checkListBox.SelectAll();
            }
            var selectedItems = checkListBox.GetSelectedItems();
            if (selectedItems && selectedItems.length == 0) {
                checkListBox.SelectAll();
                selectedItems = checkListBox.GetSelectedItems();
            }

            DestinationByCustomerCbPanelforClosed.SetText(_getSelectedItemsText(selectedItems, checkListBox));
        }
    }
    var _synchronizeListBoxValuesDestination = function (dropDown, args) {
        var checkListBox = ASPxClientControl.GetControlCollection().GetByName('checkListBoxDestinationByCustomerCbPanelforClosed');
        //checkListBox.UnselectAll();
        var texts = dropDown.GetText().split(textSeparator);
        var values = _getValuesByTexts(texts, checkListBox);
        checkListBox.SelectValues(values);
        _updateTextDestination();//dropDown.name); // for remove non-existing texts
    }
    //-------Origin------------------
    var _updateTextOrigin = function () {
        var checkListBox = ASPxClientControl.GetControlCollection().GetByName('checkListBoxOriginByCustomerCbPanelforClosed');
        if (checkListBox != null) {
            var selectedItems = checkListBox.GetSelectedItems();
            OriginByCustomerCbPanelforClosed.SetText(_getSelectedItemsText(selectedItems, checkListBox));
        }
    }
    var _updateTextOriginDefault = function () {
        var checkListBox = ASPxClientControl.GetControlCollection().GetByName('checkListBoxOriginByCustomerCbPanelforClosed');
        if (checkListBox != null) {
            if (ASPxClientControl.GetControlCollection().GetByName('Customer') != null
                && ASPxClientControl.GetControlCollection().GetByName('Customer').GetValue() >= 0) {
                checkListBox.SelectAll();
            }
            var selectedItems = checkListBox.GetSelectedItems();
            OriginByCustomerCbPanelforClosed.SetText(_getSelectedItemsText(selectedItems, checkListBox));
        }
    }
    var _synchronizeListBoxValuesOrigin = function (dropDown, args) {
        var checkListBox = ASPxClientControl.GetControlCollection().GetByName('checkListBoxOriginByCustomerCbPanelforClosed');
        //checkListBox.UnselectAll();
        var texts = dropDown.GetText().split(textSeparator);
        var values = _getValuesByTexts(texts, checkListBox);
        checkListBox.SelectValues(values);
        _updateTextOrigin();//dropDown.name); // for remove non-existing texts
    }

    //------------------- Gateway Title  -------------------------
    var _updateTextGatewayStatus = function () {
        var checkListBox = ASPxClientControl.GetControlCollection().GetByName('checkListBoxGatewayStatusIdByCustomerProgramCbPanelClosed');
        if (checkListBox != null) {
            var selectedItems = checkListBox.GetSelectedItems();
            GatewayStatusIdByCustomerProgramCbPanelClosed.SetText(_getSelectedItemsText(selectedItems, checkListBox));
        }
    }
    var _updateTextGatewayStatusDefault = function () {
        var checkListBox = ASPxClientControl.GetControlCollection().GetByName('checkListBoxGatewayStatusIdByCustomerProgramCbPanelClosed');
        if (checkListBox != null) {
            if (ASPxClientControl.GetControlCollection().GetByName('Customer') != null
                && ASPxClientControl.GetControlCollection().GetByName('Customer').GetValue() >= 0) {
                checkListBox.SelectAll();
            }
            var selectedItems = checkListBox.GetSelectedItems();
            GatewayStatusIdByCustomerProgramCbPanelClosed.SetText(_getSelectedItemsText(selectedItems, checkListBox));
        }
    }
    var _synchronizeListBoxValuesGatewayStatus = function (dropDown, args) {
        var checkListBox = ASPxClientControl.GetControlCollection().GetByName('checkListBoxGatewayStatusIdByCustomerProgramCbPanelClosed');
        //checkListBox.UnselectAll();
        var texts = dropDown.GetText().split(textSeparator);
        var values = _getValuesByTexts(texts, checkListBox);
        checkListBox.SelectValues(values);
        _updateTextGatewayStatus();//dropDown.name); // for remove non-existing texts
    }
    //------------------- Service mode-------------------------
    var _updateTextServiceMode = function () {
        var checkListBox = ASPxClientControl.GetControlCollection().GetByName('checkListBoxServiceModeByCustomerCbPanelforClosed');
        if (checkListBox != null) {
            var selectedItems = checkListBox.GetSelectedItems();
            ServiceModeByCustomerCbPanelforClosed.SetText(_getSelectedItemsText(selectedItems, checkListBox));
        }
    }
    var _updateTextServiceModeDefault = function () {
        var checkListBox = ASPxClientControl.GetControlCollection().GetByName('checkListBoxServiceModeByCustomerCbPanelforClosed');
        if (checkListBox != null) {
            if (ASPxClientControl.GetControlCollection().GetByName('Customer') != null
                && ASPxClientControl.GetControlCollection().GetByName('Customer').GetValue() >= 0) {
                checkListBox.SelectAll();
            }
            var selectedItems = checkListBox.GetSelectedItems();
            ServiceModeByCustomerCbPanelforClosed.SetText(_getSelectedItemsText(selectedItems, checkListBox));
        }
    }
    var _synchronizeListBoxValuesServiceMode = function (dropDown, args) {
        var checkListBox = ASPxClientControl.GetControlCollection().GetByName('checkListBoxServiceModeByCustomerCbPanelforClosed');
        //checkListBox.UnselectAll();
        var texts = dropDown.GetText().split(textSeparator);
        var values = _getValuesByTexts(texts, checkListBox);
        checkListBox.SelectValues(values);
        _updateTextServiceMode();//dropDown.name); // for remove non-existing texts
    }

    //------------------- Product Type-------------------------
    var _updateTextProductType = function () {
        var checkListBox = ASPxClientControl.GetControlCollection().GetByName('checkListBoxProductTypeByCustomerCbPanelforClosed');
        if (checkListBox != null) {
            var selectedItems = checkListBox.GetSelectedItems();
            ProductTypeByCustomerCbPanelforClosed.SetText(_getSelectedItemsText(selectedItems, checkListBox));
        }
    }
    var _updateTextProductTypeDefault = function () {
        var checkListBox = ASPxClientControl.GetControlCollection().GetByName('checkListBoxProductTypeByCustomerCbPanelforClosed');
        if (checkListBox != null) {
            if (ASPxClientControl.GetControlCollection().GetByName('Customer') != null
                && ASPxClientControl.GetControlCollection().GetByName('Customer').GetValue() >= 0) {
                checkListBox.SelectAll();
            }
            var selectedItems = checkListBox.GetSelectedItems();
            ProductTypeByCustomerCbPanelforClosed.SetText(_getSelectedItemsText(selectedItems, checkListBox));
        }
    }
    var _synchronizeListBoxValuesProductType = function (dropDown, args) {
        var checkListBox = ASPxClientControl.GetControlCollection().GetByName('checkListBoxProductTypeByCustomerCbPanelforClosed');
        //checkListBox.UnselectAll();
        var texts = dropDown.GetText().split(textSeparator);
        var values = _getValuesByTexts(texts, checkListBox);
        checkListBox.SelectValues(values);
        _updateTextProductType();//dropDown.name); // for remove non-existing texts
    }

    //------------------- Job Channel-------------------------
    var _updateTextJobChannel = function () {
        var checkListBox = ASPxClientControl.GetControlCollection().GetByName('checkListBoxJobChannelByProgramCustomerCbPanelforClosed');
        if (checkListBox != null) {
            var selectedItems = checkListBox.GetSelectedItems();
            JobChannelByProgramCustomerCbPanelforClosed.SetText(_getSelectedItemsText(selectedItems, checkListBox));
        }
    }
    var _updateTextJobChannelDefault = function () {
        var checkListBox = ASPxClientControl.GetControlCollection().GetByName('checkListBoxJobChannelByProgramCustomerCbPanelforClosed');
        if (checkListBox != null) {
            if (ASPxClientControl.GetControlCollection().GetByName('Customer') != null
                && ASPxClientControl.GetControlCollection().GetByName('Customer').GetValue() >= 0) {
                checkListBox.SelectAll();
            }
            var selectedItems = checkListBox.GetSelectedItems();
            JobChannelByProgramCustomerCbPanelforClosed.SetText(_getSelectedItemsText(selectedItems, checkListBox));
        }
    }
    var _synchronizeListBoxValuesJobChannel = function (dropDown, args) {
        var checkListBox = ASPxClientControl.GetControlCollection().GetByName('checkListBoxJobChannelByProgramCustomerCbPanelforClosed');
        //checkListBox.UnselectAll();
        var texts = dropDown.GetText().split(textSeparator);
        var values = _getValuesByTexts(texts, checkListBox);
        checkListBox.SelectValues(values);
        _updateTextJobChannel();//dropDown.name); // for remove non-existing texts
    }

    //------------------------------------------------
    var _getSelectedItemsText = function (items, checkListBox) {
        var texts = [];
        if (items.length == checkListBox.GetItemCount() && checkListBox.GetItemCount() > 0)
            texts.push("ALL");
        else
            for (var i = 0; i < items.length; i++)
                texts.push(items[i].text);
        return texts.join(textSeparator);
    }
    var _getSelectedItemsVal = function (items, checkListBox) {
        var texts = [];
        if (items.length == checkListBox.GetItemCount() && checkListBox.GetItemCount() > 0)
            texts.push("ALL");
        else
            for (var i = 0; i < items.length; i++)
                texts.push(items[i].text);
        return texts.join(textSeparator);
    }
    var _getValuesByTexts = function (texts, checkListBox) {
        var actualValues = [];
        var item;
        for (var i = 0; i < texts.length; i++) {
            item = checkListBox.FindItemByText(texts[i]);
            if (item != null)
                actualValues.push(item.value);
        }
        return actualValues;
    }

    //------------------- Program-------------------------
    var _updateTextProgram = function () {
        var checkListBox = ASPxClientControl.GetControlCollection().GetByName('checkListBoxProgramByCustomerCbPanelforClosed');
        if (checkListBox != null) {
            var selectedItems = checkListBox.GetSelectedItems();
            ProgramByCustomerCbPanelforClosed.SetText(_getSelectedItemsValues(selectedItems, checkListBox));
        }
    }
    var _updateTextProgramDefault = function () {
        var checkListBox = ASPxClientControl.GetControlCollection().GetByName('checkListBoxProgramByCustomerCbPanelforClosed');
        if (checkListBox != null) {
            if (ASPxClientControl.GetControlCollection().GetByName('Customer') != null
                && ASPxClientControl.GetControlCollection().GetByName('Customer').GetValue() >= 0) {
                checkListBox.SelectAll();
            }
            var selectedItems = checkListBox.GetSelectedItems();
            ProgramByCustomerCbPanelforClosed.SetText(_getSelectedItemsValues(selectedItems, checkListBox));
        }
    }
    var _synchronizeListBoxValuesProgram = function (dropDown, args) {
        var checkListBox = ASPxClientControl.GetControlCollection().GetByName('checkListBoxProgramByCustomerCbPanelforClosed');
        //checkListBox.UnselectAll();
        var texts = dropDown.GetValue() == null ? null : dropDown.GetValue().split(textSeparator);
        var values = _getValuesByValues(texts, checkListBox);
        checkListBox.SelectValues(values);
        _updateTextProgram();//dropDown.name); // for remove non-existing texts
    }
    var _getSelectedItemsValues = function (items, checkListBox) {
        var texts = [];
        if (items.length == checkListBox.GetItemCount() && checkListBox.GetItemCount() > 0)
            texts.push("ALL");
        else
            for (var i = 0; i < items.length; i++)
                texts.push(items[i].text);
        return texts.join(textSeparator);
    }
    var _getValuesByValues = function (texts, checkListBox) {
        var actualValues = [];
        var item;
        if (texts != null) {
            for (var i = 0; i < texts.length; i++) {
                item = checkListBox.FindItemByText(texts[i]);
                if (item != null)
                    actualValues.push(item.text);
            }
        }
        return actualValues;
    }

    var _onVocLocationInit = function (s, e) {
        var element = s.GetMainElement();
        var checkListBox = ASPxClientControl.GetControlCollection().GetByName('checkListBoxCustomerLocationCbPanelClosed');
        while (element != null && element.tagName != "BODY") {
            if (element.tagName == "DIV") {
                ASPxClientUtils.AttachEventToElement(element, "scroll",
                    function (event) {
                        if (event.target != checkListBox.scrollDivElement)
                            s.HideDropDown();
                    });
            }
            element = element.parentNode;
        }
    }
    return {
        UpdateTextOrigin: _updateTextOrigin,
        UpdateTextOriginDefault: _updateTextOriginDefault,
        SynchronizeListBoxValuesOrigin: _synchronizeListBoxValuesOrigin,
        UpdateTextDestination: _updateTextDestination,
        UpdateTextDestinationDefault: _updateTextDestinationDefault,
        SynchronizeListBoxValuesDestination: _synchronizeListBoxValuesDestination,
        UpdateValueDestination: _updateValueDestination,
        UpdateValueDestinationDefault: _updateValueDestinationDefault,
        SynchronizeListBoxValuesDestinationValue: _synchronizeListBoxValuesDestinationValue,
        GetSelectedItemsText: _getSelectedItemsText,
        GetSelectedItemsVal: _getSelectedItemsVal,
        GetValuesByTexts: _getValuesByTexts,
        UpdateTextBrand: _updateTextBrand,
        UpdateTextBrandDefault: _updateTextBrandDefault,
        SynchronizeListBoxValuesBrand: _synchronizeListBoxValuesBrand,
        UpdateTextGatewayStatus: _updateTextGatewayStatus,
        UpdateTextGatewayStatusDefault: _updateTextGatewayStatusDefault,
        SynchronizeListBoxValuesGatewayStatus: _synchronizeListBoxValuesGatewayStatus,
        UpdateTextServiceMode: _updateTextServiceMode,
        UpdateTextServiceModeDefault: _updateTextServiceModeDefault,
        SynchronizeListBoxValuesServiceMode: _synchronizeListBoxValuesServiceMode,
        UpdateTextProductType: _updateTextProductType,
        UpdateTextProductTypeDefault: _updateTextProductTypeDefault,
        SynchronizeListBoxValuesProductType: _synchronizeListBoxValuesProductType,
        UpdateTextJobChannel: _updateTextJobChannel,
        UpdateTextJobChannelDefault: _updateTextJobChannelDefault,
        SynchronizeListBoxValuesJobChannel: _synchronizeListBoxValuesJobChannel,
        UpdateTextProgram: _updateTextProgram,
        UpdateTextProgramDefault: _updateTextProgramDefault,
        SynchronizeListBoxValuesProgram: _synchronizeListBoxValuesProgram,
        UpdateTextLocation: _updateTextLocation,
        UpdateTextLocationDefault: _updateTextLocationDefault,
        SynchronizeListBoxValuesLocation: _synchronizeListBoxValuesLocation,
        OnVocLocationInit: _onVocLocationInit,
    }
})();

M4PLCommon.DropDownEdit = (function () {
    var textSeparator = ",";
    function _onListBoxSelectionChanged(s, args) {
        _updateText(s);
    }

    var _initDestinationListBox = function (s, e, selectedLocation) {
        var checkListBox = ASPxClientControl.GetControlCollection().GetByName('vdcPrefLocationsListBox');
        if (checkListBox != null) {
            if (selectedLocation !== null && selectedLocation !== undefined && selectedLocation.length > 0 && selectedLocation[0] != 'ALL') {
                checkListBox.SelectValues(selectedLocation);
            }
            var selectedItems = checkListBox.GetSelectedItems();
            //if (selectedItems && selectedItems.length == 0) {
            //    checkListBox.SelectAll();
            //    selectedItems = checkListBox.GetSelectedItems();
            //}
            var VdcPrefLocations = ASPxClientControl.GetControlCollection().GetByName("vdcPrefLocations");
            if (VdcPrefLocations != null)
                VdcPrefLocations.SetText(_getSelectedItemsText(selectedItems));
        }
    }

    var _updateText = function (listBox) {
        var selectedItems = listBox.GetSelectedItems();

        var dropDownControl = ASPxClientControl.GetControlCollection().GetByName(listBox.ownerName);
        dropDownControl.SetValue(_getSelectedItemsValue(selectedItems));
        dropDownControl.SetText(_getSelectedItemsText(selectedItems));
    }
    var _synchronizeListBoxValues = function (dropDown, args) {
        var checkListControl = ASPxClientControl.GetControlCollection().GetByName(dropDown.name + "ListBox");
        checkListControl.ownerName = dropDown.name;

        var values = _getValuesByTexts(checkListControl, dropDown.GetText().split(textSeparator));
        checkListControl.SelectValues(values);
        _updateText(checkListControl);
    }
    var _closeUp = function (s, e) {
        var checkListControl = ASPxClientControl.GetControlCollection().GetByName(s.name + "ListBox");
        checkListControl.ownerName = s.name;

        if (checkListControl != null) {
            var selectedItems = checkListControl.GetSelectedItems();

            $.ajax({
                type: "Post",
                url: "/Common/SavePrefLocations",
                data: { "selectedItems": _getSelectedItemsValue(selectedItems) },
                success: function (response) {
                    if (response.status && response.status === true) {
                        var locations = response.locations;

                        var checkListBox = ASPxClientControl.GetControlCollection().GetByName('checkListBoxDestinationByCustomerCbPanelforClosed');
                        if (locations !== null && locations !== undefined && locations.length > 0) {
                            var res = locations.map(t => t.PPPVendorLocationCode);//locations.split(",");
                            checkListBox.UnselectAll();
                            checkListBox.SelectValues($.unique(res));
                        }
                        else {
                            checkListBox.SelectAll();
                        }
                        var destinationCtrl = ASPxClientControl.GetControlCollection().GetByName('DestinationByCustomerCbPanelforClosed');
                        var selectedItems = checkListBox.GetSelectedItems();
                        if (selectedItems == null || selectedItems.length == 0 || selectedItems == undefined) {
                            checkListBox.SelectAll();
                            selectedItems = checkListBox.GetSelectedItems();
                        }
                        if (destinationCtrl != null) {
                            destinationCtrl.SetText(_getSelectedItemsText(selectedItems, checkListBox));
                            if (ASPxClientControl.GetControlCollection().GetByName("JobCardViewTileCbPanel") && ASPxClientControl.GetControlCollection().GetByName('DestinationByCustomerCbPanelforClosed')) {
                                var strRoute = M4PLCommon.Common.GetParameterValueFromRoute('strRoute', JobCardViewTileCbPanel.callbackUrl);
                                var route = JSON.parse(strRoute);
                                if (destinationCtrl.GetValue() != null && destinationCtrl.GetValue() != undefined) {
                                    var dest = destinationCtrl.GetValue().split(',').map(String);
                                    if (dest !== null && dest !== undefined && dest.length > 0)
                                        route.Location = dest;
                                }
                                JobCardViewTileCbPanel.callbackCustomArgs["strRoute"] = JSON.stringify(route);
                                JobCardViewTileCbPanel.PerformCallback({ strRoute: JSON.stringify(route) });

                                DevExCtrl.LoadingPanel.Show(GlobalLoadingPanel);
                            }
                        }
                    }
                }
            });
        }
    }
    var _getSelectedItemsValue = function (items) {
        var texts = [];
        for (var i = 0; i < items.length; i++)
            texts.push(items[i].value);
        return texts.join(textSeparator);
    }
    var _getSelectedItemsText = function (items, listBox) {
        var texts = [];
        //if (listBox != null && listBox != undefinded && listBox.GetItemCount() == texts.length) {
        //    texts.push("ALL");
        //}
        //else {
        for (var i = 0; i < items.length; i++)
            texts.push(items[i].text);
        //}
        return texts.join(textSeparator);
    }
    var _getValuesByTexts = function (checkListControl, texts) {
        var actualValues = [];
        var item;
        for (var i = 0; i < texts.length; i++) {
            item = checkListControl.FindItemByText(texts[i]);
            if (item != null)
                actualValues.push(item.value);
        }
        return actualValues;
    }
    return {
        InitDestinationListBox: _initDestinationListBox,
        OnListBoxSelectionChanged: _onListBoxSelectionChanged,
        SynchronizeListBoxValues: _synchronizeListBoxValues,
        CloseUp: _closeUp
    }
})();

M4PLCommon.PrgGateway = (function () {
    var textSeparator = ",";
    function _onListBoxSelectionChanged(s, args) {
        ASPxClientControl.GetControlCollection().GetByName('MappingIdListBox');
        _updateText(s);
    }

    var _initNextGatewayListBox = function (s, e, selectedNextGateway) {
        var checkListBox = ASPxClientControl.GetControlCollection().GetByName('MappingIdListBox');
        if (checkListBox != null) {
            if (selectedNextGateway !== null && selectedNextGateway !== undefined && selectedNextGateway.length > 0 && selectedNextGateway[0] != 'ALL') {
                checkListBox.SelectValues(selectedNextGateway);
            }
            var selectedItems = checkListBox.GetSelectedItems();
            //if (selectedItems && selectedItems.length == 0) {
            //    checkListBox.SelectAll();
            //    selectedItems = checkListBox.GetSelectedItems();
            //}
            var NextGateway = ASPxClientControl.GetControlCollection().GetByName("MappingId");
            if (NextGateway != null)
                NextGateway.SetText(_getSelectedItemsText(selectedItems));
        }
    }

    var _updateText = function (listBox) {
        var selectedItems = listBox.GetSelectedItems();

        var dropDownControl = ASPxClientControl.GetControlCollection().GetByName(listBox.ownerName);
        dropDownControl.SetValue(_getSelectedItemsValue(selectedItems));
        dropDownControl.SetText(_getSelectedItemsText(selectedItems));
    }
    var _synchronizeListBoxValues = function (dropDown, args) {
        var checkListControl = ASPxClientControl.GetControlCollection().GetByName(dropDown.name + "ListBox");
        checkListControl.ownerName = dropDown.name;

        var values = _getValuesByTexts(checkListControl, dropDown.GetText().split(textSeparator));
        checkListControl.SelectValues(values);
        _updateText(checkListControl);
    }
    var _closeUp = function (s, e) {
        var checkListControl = ASPxClientControl.GetControlCollection().GetByName(s.name + "ListBox");
        checkListControl.ownerName = s.name;

        if (checkListControl != null) {
            var selectedItems = checkListControl.GetSelectedItems();
        }
    }
    var _getSelectedItemsValue = function (items) {
        var texts = [];
        for (var i = 0; i < items.length; i++)
            texts.push(items[i].value);
        return texts.join(textSeparator);
    }
    var _getSelectedItemsText = function (items, listBox) {
        var texts = [];
        //if (listBox != null && listBox != undefinded && listBox.GetItemCount() == texts.length) {
        //    texts.push("ALL");
        //}
        //else {
        for (var i = 0; i < items.length; i++)
            texts.push(items[i].text);
        //}
        return texts.join(textSeparator);
    }
    var _getValuesByTexts = function (checkListControl, texts) {
        var actualValues = [];
        var item;
        for (var i = 0; i < texts.length; i++) {
            item = checkListControl.FindItemByText(texts[i]);
            if (item != null)
                actualValues.push(item.value);
        }
        return actualValues;
    }
    var _onOrdertypedChange = function (s, e, programId) {
        var orderType = s.GetValue();
        var shipmentType = ASPxClientControl.GetControlCollection().GetByName("PgdShipmentType_popup").GetValue();
        var mappingctrl = ASPxClientControl.GetControlCollection().GetByName("MappingIdCbPanel");
        var gatewayType = ASPxClientControl.GetControlCollection().GetByName("GatewayTypeId_popup").GetValue();
        if (mappingctrl != null) {
            mappingctrl.PerformCallback({ 'selectedItems': '', 'programId': programId, 'shipmentType': shipmentType, 'orderType': orderType, 'gatewayType': gatewayType });
        }
    }
    var _onShipmenttypedChange = function (s, e, programId) {
        var shipmentType = s.GetValue();
        var orderType = ASPxClientControl.GetControlCollection().GetByName("PgdOrderType_popup").GetValue();
        var mappingctrl = ASPxClientControl.GetControlCollection().GetByName("MappingIdCbPanel");
        var gatewayType = ASPxClientControl.GetControlCollection().GetByName("GatewayTypeId_popup").GetValue();

        if (mappingctrl != null) {
            mappingctrl.PerformCallback({ 'selectedItems': '', 'programId': programId, 'shipmentType': shipmentType, 'orderType': orderType, 'gatewayType': gatewayType });
        }
    }
    var _onGatewayTypeIdChange = function (s, e, programId) {
        var gatewayType = s.GetValue();
        var orderType = ASPxClientControl.GetControlCollection().GetByName("PgdOrderType_popup").GetValue();
        var mappingctrl = ASPxClientControl.GetControlCollection().GetByName("MappingIdCbPanel");
        var shipmentType = ASPxClientControl.GetControlCollection().GetByName("PgdShipmentType_popup").GetValue();

        if (mappingctrl != null) {
            mappingctrl.PerformCallback({ 'selectedItems': '', 'programId': programId, 'shipmentType': shipmentType, 'orderType': orderType, 'gatewayType': gatewayType });
        }
    }

    return {
        InitNextGatewayListBox: _initNextGatewayListBox,
        OnListBoxSelectionChanged: _onListBoxSelectionChanged,
        SynchronizeListBoxValues: _synchronizeListBoxValues,
        CloseUp: _closeUp,
        OnOrdertypedChange: _onOrdertypedChange,
        OnShipmenttypedChange: _onShipmenttypedChange,
        OnGatewayTypeIdChange: _onGatewayTypeIdChange,
    }
})();

M4PLCommon.CardView = (function () {
    var _init = function (s, e) {
        $.each($("#CardView tbody td table tbody td div"), function (key, value) {
            if (value != "" && value != undefined && value.innerText != "" && value.innerText.includes("Card Type:")) {
                var valueCardType = value.innerText.replace('Card Type: ', '');
                value.innerText = valueCardType.replace(/[0-9]/g, '');
            }
        });
    };

    return {
        Init: _init
    }
})();

M4PLCommon.Error = (function () {
    var _checkServerError = function () {
        $.ajax({
            type: "GET",
            async: false,
            cache: false,
            url: "/Common/GetErrorMessageRoute",
            success: function (response) {
                if (response != "") {
                    DisplayMessageControl.PerformCallback({ 'strDisplayMessage': JSON.stringify(response) })
                    response = "";
                }
            },
            error: function (err) {
                console.log("error", err);
            }
        });
    };

    var _initDisplayMessage = function (title, text) {
        var displaymessage =
        {
            ScreenTitle: title,
            Description: text,
            MessageType: 2,
            Code: 'JobDocumentReport'
        };
        DisplayMessageControl.PerformCallback({ strDisplayMessage: JSON.stringify(displaymessage) });
    }

    return {
        CheckServerError: _checkServerError,
        InitDisplayMessage: _initDisplayMessage,
    }
})();

M4PLCommon.DocumentStatus = (function () {
    var _isPODAttachedForJob = function (jobId, jobIds) {
        var isPODUploaded = false;
        DevExCtrl.LoadingPanel.Show(GlobalLoadingPanel);
        $.ajax({
            type: "GET",
            url: "/Common/GetDocumentStatusByJobId?jobId=" + jobId + "&jobIds=" + jobIds,
            contentType: 'application/json; charset=utf-8',
            async: false,
            success: function (response) {
                if (response && response.status && response.status === true && response.documentStatus != null) {
                    isPODUploaded = response.documentStatus.IsPODPresent;
                    DevExCtrl.LoadingPanel.Hide(GlobalLoadingPanel);
                }
            },
            error: function (err) {
                DevExCtrl.LoadingPanel.Hide(GlobalLoadingPanel);
            },
            failure: function (err) {
                DevExCtrl.LoadingPanel.Hide(GlobalLoadingPanel);
            }
        });

        return isPODUploaded
    };

    var _isAttachmentPresentForJob = function (jobId, jobIds) {
        var isjobAttachmentPresent = false;
        DevExCtrl.LoadingPanel.Show(GlobalLoadingPanel);
        $.ajax({
            type: "GET",
            url: "/Common/GetDocumentStatusByJobId?jobId=" + jobId + "&jobIds=" + jobIds,
            contentType: 'application/json; charset=utf-8',
            async: false,
            success: function (response) {
                if (response && response.status && response.status === true && response.documentStatus != null) {
                    isjobAttachmentPresent = response.documentStatus.IsAttachmentPresent;
                    DevExCtrl.LoadingPanel.Hide(GlobalLoadingPanel);
                }
            },
            error: function (err) {
                DevExCtrl.LoadingPanel.Hide(GlobalLoadingPanel);
            },
            failure: function (err) {
                DevExCtrl.LoadingPanel.Hide(GlobalLoadingPanel);
            }
        });

        return isjobAttachmentPresent
    };

    var _isPriceCodeDataPresentForJob = function (jobId, jobIds) {
        var isPriceCodeDataPresent = false;
        DevExCtrl.LoadingPanel.Show(GlobalLoadingPanel);
        $.ajax({
            type: "GET",
            url: "/Common/IsPriceCodeDataPresentForJob?jobId=" + jobId + "&jobIds=" + jobIds,
            contentType: 'application/json; charset=utf-8',
            async: false,
            success: function (response) {
                if (response && response.status && response.status === true && response.documentStatus != null) {
                    isPriceCodeDataPresent = response.documentStatus.IsAttachmentPresent;
                    DevExCtrl.LoadingPanel.Hide(GlobalLoadingPanel);
                }
            },
            error: function (err) {
                DevExCtrl.LoadingPanel.Hide(GlobalLoadingPanel);
            },
            failure: function (err) {
                DevExCtrl.LoadingPanel.Hide(GlobalLoadingPanel);
            }
        });

        return isPriceCodeDataPresent
    };

    var _isPriceCodeDataPresentForJobInNAV = function (jobId, jobIds) {

        var isPriceCodeDataPresent = false;
        DevExCtrl.LoadingPanel.Show(GlobalLoadingPanel);
        $.ajax({
            type: "GET",
            url: "/Common/IsPriceCodeDataPresentForJobInNAV?jobId=" + jobId + "&jobIds=" + jobIds,
            contentType: 'application/json; charset=utf-8',
            async: false,
            success: function (response) {
                if (response && response.status && response.status === true && response.documentStatus != null) {
                    isPriceCodeDataPresent = response.documentStatus.IsAttachmentPresent;
                    DevExCtrl.LoadingPanel.Hide(GlobalLoadingPanel);
                }
            },
            error: function (err) {
                DevExCtrl.LoadingPanel.Hide(GlobalLoadingPanel);
            },
            failure: function (err) {
                DevExCtrl.LoadingPanel.Hide(GlobalLoadingPanel);
            }
        });



        return isPriceCodeDataPresent
    };
    var _isCostCodeDataPresentForJobInNAV = function (jobId, jobIds) {
        var isCostCodeDataPresent = false;
        DevExCtrl.LoadingPanel.Show(GlobalLoadingPanel);
        $.ajax({
            type: "GET",
            url: "/Common/IsCostCodeDataPresentForJobInNAV?jobId=" + jobId + "&jobIds=" + jobIds,
            contentType: 'application/json; charset=utf-8',
            async: false,
            success: function (response) {
                if (response && response.status && response.status === true && response.documentStatus != null) {
                    isCostCodeDataPresent = response.documentStatus.IsAttachmentPresent;
                    DevExCtrl.LoadingPanel.Hide(GlobalLoadingPanel);
                }
            },
            error: function (err) {
                DevExCtrl.LoadingPanel.Hide(GlobalLoadingPanel);
            },
            failure: function (err) {
                DevExCtrl.LoadingPanel.Hide(GlobalLoadingPanel);
            }
        });

        return isCostCodeDataPresent
    };

    var _isCostCodeDataPresentForJob = function (jobId, jobIds) {
        var isCostCodeDataPresent = false;
        DevExCtrl.LoadingPanel.Show(GlobalLoadingPanel);
        $.ajax({
            type: "GET",
            url: "/Common/IsCostCodeDataPresentForJob?jobId=" + jobId + "&jobIds=" + jobIds,
            contentType: 'application/json; charset=utf-8',
            async: false,
            success: function (response) {
                if (response && response.status && response.status === true && response.documentStatus != null) {
                    isCostCodeDataPresent = response.documentStatus.IsAttachmentPresent;
                    DevExCtrl.LoadingPanel.Hide(GlobalLoadingPanel);
                }
            },
            error: function (err) {
                DevExCtrl.LoadingPanel.Hide(GlobalLoadingPanel);
            },
            failure: function (err) {
                DevExCtrl.LoadingPanel.Hide(GlobalLoadingPanel);
            }
        });

        return isCostCodeDataPresent
    };

    var _isHistoryPresentForJob = function (jobId, jobIds) {
        var isHistoryDataPresent = false;
        DevExCtrl.LoadingPanel.Show(GlobalLoadingPanel);
        $.ajax({
            type: "GET",
            url: "/Common/IsHistoryPresentForJob?jobId=" + jobId + "&jobIds=" + jobIds,
            contentType: 'application/json; charset=utf-8',
            async: false,
            success: function (response) {
                if (response && response.status && response.status === true && response.documentStatus != null) {
                    isHistoryDataPresent = response.documentStatus.IsHistoryPresent;
                    DevExCtrl.LoadingPanel.Hide(GlobalLoadingPanel);
                }
            },
            error: function (err) {
                DevExCtrl.LoadingPanel.Hide(GlobalLoadingPanel);
            },
            failure: function (err) {
                DevExCtrl.LoadingPanel.Hide(GlobalLoadingPanel);
            }
        });

        return isHistoryDataPresent
    };

    var _podMissingDisplayMessage = function (title, text) {
        var displaymessage =
        {
            ScreenTitle: title,
            Description: text,
            MessageType: 2,
            Code: 'JobPODUploaded'
        };
        DisplayMessageControl.PerformCallback({ strDisplayMessage: JSON.stringify(displaymessage) });
    };

    var _displayMessage = function (title, text, messageType, code) {
        var displaymessage =
        {
            ScreenTitle: title,
            Description: text,
            MessageType: messageType,
            Code: code
        };
        DisplayMessageControl.PerformCallback({ strDisplayMessage: JSON.stringify(displaymessage) });
    };

    var _jobPriceCodeMissingDisplayMessage = function (title, text) {
        var displaymessage =
        {
            ScreenTitle: title,
            Description: text,
            MessageType: 2,
            Code: 'JobPriceCodeMissing'
        };

        DisplayMessageControl.PerformCallback({ strDisplayMessage: JSON.stringify(displaymessage) });
    };

    var _jobCostCodeMissingDisplayMessage = function (title, text) {
        var displaymessage =
        {
            ScreenTitle: title,
            Description: text,
            MessageType: 2,
            Code: 'JobCostCodeMissing'
        };

        DisplayMessageControl.PerformCallback({ strDisplayMessage: JSON.stringify(displaymessage) });
    };

    var _jobHistoryMissingDisplayMessage = function (title, text) {
        var displaymessage =
        {
            ScreenTitle: title,
            Description: text,
            MessageType: 2,
            Code: 'JobHistoryMissing'
        };

        DisplayMessageControl.PerformCallback({ strDisplayMessage: JSON.stringify(displaymessage) });
    };

    var _batchJobCreatedDisplayMessage = function (title, text) {
        var displaymessage =
        {
            ScreenTitle: title,
            Description: text,
            MessageType: 2,
            Code: 'ImportJobData'
        };

        DisplayMessageControl.PerformCallback({ strDisplayMessage: JSON.stringify(displaymessage) });
    };

    return {
        IsPODAttachedForJob: _isPODAttachedForJob,
        IsAttachmentPresentForJob: _isAttachmentPresentForJob,
        IsPriceCodeDataPresentForJob: _isPriceCodeDataPresentForJob,
        IsCostCodeDataPresentForJob: _isCostCodeDataPresentForJob,
        IsHistoryPresentForJob: _isHistoryPresentForJob,
        PODMissingDisplayMessage: _podMissingDisplayMessage,
        DisplayMessage: _displayMessage,
        JobPriceCodeMissingDisplayMessage: _jobPriceCodeMissingDisplayMessage,
        JobCostCodeMissingDisplayMessage: _jobCostCodeMissingDisplayMessage,
        JobHistoryMissingDisplayMessage: _jobHistoryMissingDisplayMessage,
        BatchJobCreatedDisplayMessage: _batchJobCreatedDisplayMessage,
        IsPriceCodeDataPresentForJobInNAV: _isPriceCodeDataPresentForJobInNAV,
        IsCostCodeDataPresentForJobInNAV: _isCostCodeDataPresentForJobInNAV,
    }
})();

M4PLCommon.DisplayMessage = (function () {
    var _defaultClientOk = function () {
        var okCtrl = ASPxClientControl.GetControlCollection().GetByName("btnOk");
        if (okCtrl != undefined && okCtrl != null) {
            okCtrl.DoClick();
        }

        var saveCtrl = ASPxClientControl.GetControlCollection().GetByName("btnSave");
        if (saveCtrl != undefined && saveCtrl != null) {
            saveCtrl.DoClick();
        }
    };

    return {
        DefaultClientOk: _defaultClientOk
    }
})();

M4PLCommon.Clipboard = (function () {

    var _setClipboard = function (text) {
        if (navigator != undefined && navigator.clipboard != undefined) {
            navigator.clipboard.writeText(text).then(function () {
                /* clipboard successfully set */
            }, function () {
                /* clipboard write failed */
            });
        } else {
            localStorage.setItem("CopiedText", text);
        }
    }

    var _getClipboard = function (ctrl, isInnerText) {
        if (navigator != undefined && navigator.clipboard != undefined) {
            if (isInnerText)
                navigator.clipboard.readText().then(function (clipText) { ctrl.innerText = clipText; ctrl.value = clipText });
            else
                navigator.clipboard.readText().then(clipText => ctrl.SetValue(clipText));
        } else {
            var copiedText = localStorage.getItem("CopiedText");
            if (copiedText != undefined && copiedText != '' && copiedText != null)
                if (isInnerText) {
                    ctrl.innerText = copiedText;
                    ctrl.value = copiedText;
                }
                else
                    ctrl.SetValue(clipText)
        }
    }

    return {
        SetClipboard: _setClipboard,
        GetClipboard: _getClipboard
    }
})();

M4PLCommon.ToAddressSubscriber = (function () {
    var textSeparator = ",";
    function _onListBoxSelectionChanged(s, args) {
        _updateText(s);
    }

    var _initToAddressSubscriberListBox = function (s, e, selectedToAddressSubscriber) {

        if (selectedToAddressSubscriber != null && selectedToAddressSubscriber.indexOf("3") > -1)
            $(".isToEmail").show();
        else
            $(".isToEmail").hide();

        var checkListBox = ASPxClientControl.GetControlCollection().GetByName('ToAddressSubscriberIdListBox');
        if (checkListBox != null) {
            if (selectedToAddressSubscriber !== null && selectedToAddressSubscriber !== undefined && selectedToAddressSubscriber.length > 0 && selectedToAddressSubscriber[0] != 'ALL') {
                checkListBox.SelectValues(selectedToAddressSubscriber);
            }
            var selectedItems = checkListBox.GetSelectedItems();

            var ToAddressSubscriber = ASPxClientControl.GetControlCollection().GetByName("ToAddressSubscriberId");
            if (ToAddressSubscriber != null)
                ToAddressSubscriber.SetText(_getSelectedItemsText(selectedItems));
        }
    }

    var _updateText = function (listBox, Id) {
        var selectedItems = listBox.GetSelectedItems();
        var isCustomExists = _isElementExistsInList(selectedItems, 'Custom');
        if (isCustomExists)
            $(".isToEmail").show();
        else
            $(".isToEmail").hide();

        var dropDownControl = ASPxClientControl.GetControlCollection().GetByName(listBox.ownerName);
        dropDownControl.SetValue(_getSelectedItemsValue(selectedItems));
        var values = _getSelectedItemsText(selectedItems);
        dropDownControl.SetText(values);
    }

    var _synchronizeListBoxValues = function (dropDown, args) {
        var checkListControl = ASPxClientControl.GetControlCollection().GetByName(dropDown.name + "ListBox");
        checkListControl.ownerName = dropDown.name;

        var values = _getValuesByTexts(checkListControl, dropDown.GetText().split(textSeparator));
        checkListControl.SelectValues(values);
        _updateText(checkListControl);
    }

    var _closeUp = function (s, e) {
        var checkListControl = ASPxClientControl.GetControlCollection().GetByName(s.name + "ListBox");
        checkListControl.ownerName = s.name;

        if (checkListControl != null) {
            var selectedItems = checkListControl.GetSelectedItems();
        }
    }

    var _isElementExistsInList = function (list, item) {
        for (var i = 0; i < list.length; i++) {
            if (list[i].text == item)
                return true;
        }
        return false;
    }

    var _getSelectedItemsValue = function (items) {
        var texts = [];
        for (var i = 0; i < items.length; i++)
            texts.push(items[i].value);
        return texts.join(textSeparator);
    }

    var _getSelectedItemsText = function (items, listBox) {
        var texts = [];
        //if (listBox != null && listBox != undefinded && listBox.GetItemCount() == texts.length) {
        //    texts.push("ALL");
        //}
        //else {
        for (var i = 0; i < items.length; i++)
            texts.push(items[i].text);
        //}
        return texts.join(textSeparator);
    }

    var _getValuesByTexts = function (checkListControl, texts) {
        var actualValues = [];
        var item;
        for (var i = 0; i < texts.length; i++) {
            item = checkListControl.FindItemByText(texts[i]);
            if (item != null)
                actualValues.push(item.value);
        }
        return actualValues;
    }

    return {
        InitToAddressSubscriberListBox: _initToAddressSubscriberListBox,
        OnListBoxSelectionChanged: _onListBoxSelectionChanged,
        SynchronizeListBoxValues: _synchronizeListBoxValues,
        CloseUp: _closeUp
    }
})();

M4PLCommon.EmailCCAddressSubscriber = (function () {
    var textSeparator = ",";
    function _onListBoxSelectionChanged(s, args) {
        _updateText(s);
    }

    var _initEmailCCAddressSubscriberListBox = function (s, e, selectedEmailCCAddressSubscriber) {

        if (selectedEmailCCAddressSubscriber != null && selectedEmailCCAddressSubscriber.indexOf("3") > -1)
            $(".isCcEMail").show();
        else
            $(".isCcEMail").hide();

        var checkListBox = ASPxClientControl.GetControlCollection().GetByName('EmailCCAddressSubscriberIdListBox');
        if (checkListBox != null) {
            if (selectedEmailCCAddressSubscriber !== null && selectedEmailCCAddressSubscriber !== undefined && selectedEmailCCAddressSubscriber.length > 0 && selectedEmailCCAddressSubscriber[0] != 'ALL') {
                checkListBox.SelectValues(selectedEmailCCAddressSubscriber);
            }

            var selectedItems = checkListBox.GetSelectedItems();
            var EmailCCAddressSubscriber = ASPxClientControl.GetControlCollection().GetByName("EmailCCAddressSubscriberId");
            if (EmailCCAddressSubscriber != null)
                EmailCCAddressSubscriber.SetText(_getSelectedItemsText(selectedItems));
        }
    }

    var _updateText = function (listBox, Id) {
        var selectedItems = listBox.GetSelectedItems();
        var isCustomExists = _isElementExistsInList(selectedItems, 'Custom');

        if (isCustomExists)
            $(".isCcEMail").show();
        else
            $(".isCcEMail").hide();

        var dropDownControl = ASPxClientControl.GetControlCollection().GetByName(listBox.ownerName);
        dropDownControl.SetValue(_getSelectedItemsValue(selectedItems));
        var values = _getSelectedItemsText(selectedItems);
        dropDownControl.SetText(values);
    }

    var _synchronizeListBoxValues = function (dropDown, args) {
        var checkListControl = ASPxClientControl.GetControlCollection().GetByName(dropDown.name + "ListBox");
        checkListControl.ownerName = dropDown.name;

        var values = _getValuesByTexts(checkListControl, dropDown.GetText().split(textSeparator));
        checkListControl.SelectValues(values);
        _updateText(checkListControl);
    }

    var _closeUp = function (s, e) {
        var checkListControl = ASPxClientControl.GetControlCollection().GetByName(s.name + "ListBox");
        checkListControl.ownerName = s.name;

        if (checkListControl != null) {
            var selectedItems = checkListControl.GetSelectedItems();
        }
    }

    var _isElementExistsInList = function (list, item) {
        for (var i = 0; i < list.length; i++) {
            if (list[i].text == item)
                return true;
        }
        return false;
    }

    var _getSelectedItemsValue = function (items) {
        var texts = [];
        for (var i = 0; i < items.length; i++)
            texts.push(items[i].value);
        return texts.join(textSeparator);
    }

    var _getSelectedItemsText = function (items, listBox) {
        var texts = [];
        //if (listBox != null && listBox != undefinded && listBox.GetItemCount() == texts.length) {
        //    texts.push("ALL");
        //}
        //else {
        for (var i = 0; i < items.length; i++)
            texts.push(items[i].text);
        //}
        return texts.join(textSeparator);
    }

    var _getValuesByTexts = function (checkListControl, texts) {
        var actualValues = [];
        var item;
        for (var i = 0; i < texts.length; i++) {
            item = checkListControl.FindItemByText(texts[i]);
            if (item != null)
                actualValues.push(item.value);
        }
        return actualValues;
    }

    return {
        InitEmailCCAddressSubscriberListBox: _initEmailCCAddressSubscriberListBox,
        OnListBoxSelectionChanged: _onListBoxSelectionChanged,
        SynchronizeListBoxValues: _synchronizeListBoxValues,
        CloseUp: _closeUp
    }
})();

M4PLCommon.NavRemittance = (function () {

    var _downloadInvoice = function () {
        $(".remittance").css("display", "none");
        $(".remittance-processing").css("display", "block");
        var checkNo = ASPxClientControl.GetControlCollection().GetByName("ChequeNo");
        if (checkNo != null && ChequeNo != "" && ChequeNo != undefined) {
            $.get(window.location.origin + "/Finance/NavRemittance/IsInvoiceAvailable" + "?checkNo=" + checkNo.GetValue(), function (data) {
                $(".remittance").css("display", "none");
                if (data != undefined && data != null && (data.Status || data.Status == 'true')) {
                    $(".remittance-sucess").css("display", "block");
                    window.open(window.location.origin + "/Finance/NavRemittance/DownloadInvoice");
                }
                else if (data != undefined && data != null) {
                    $(".remittance-fail").empty().append(data.Message);
                    $(".remittance-fail").css("display", "block");
                }
                else {
                    $(".remittance-fail").css("display", "block");
                }
            });
        }
    }

    return {
        DownloadInvoice: _downloadInvoice
    }
})();

M4PLCommon.JobMultiSelect = (function () {
    var _actionDropDownChange = function (s, e) {
        var MultiActionCtrl = ASPxClientControl.GetControlCollection().GetByName("MultiActionComboBox");
        var multiSubActionCtrl = ASPxClientControl.GetControlCollection().GetByName("MultiSubActionComboBox");
        if (multiSubActionCtrl != null && multiSubActionCtrl != undefined
            && MultiActionCtrl != null && MultiActionCtrl != undefined) {
            var selectedVal = MultiActionCtrl.GetValue();
            if (selectedVal != undefined && selectedVal != "" && selectedVal != null) {
                var btnSubmitActionGatewayCtrl = ASPxClientControl.GetControlCollection().GetByName("BtnSubmitActionGateway");
                if (btnSubmitActionGatewayCtrl != undefined && btnSubmitActionGatewayCtrl != null) {
                    btnSubmitActionGatewayCtrl.SetVisible(false);
                }
                multiSubActionCtrl.PerformCallback({ actionCode: selectedVal });
            }
            else {
                multiSubActionCtrl.listBox.ClearItems();
            }
        }
    }

    var _subActionDropDownChange = function (s, e) {
        var entity = s.GetValue();
        var btnSubmitActionGatewayCtrl = ASPxClientControl.GetControlCollection().GetByName("BtnSubmitActionGateway");
        if (entity != null && entity != undefined && entity != "" && btnSubmitActionGatewayCtrl != undefined && btnSubmitActionGatewayCtrl != null) {
            btnSubmitActionGatewayCtrl.SetVisible(true);
        }
        else {
            btnSubmitActionGatewayCtrl.SetVisible(false);
        }
    }

    var _btnSubmitActionGateway = function (s, e, strRoute) {
        var multiSubActionCtrl = ASPxClientControl.GetControlCollection().GetByName("MultiSubActionComboBox");
        if (multiSubActionCtrl != undefined && multiSubActionCtrl != null) {
            var code = multiSubActionCtrl.GetValue();
            var title = multiSubActionCtrl.GetText();
            if (code != "" && title != "" && code != undefined && title != undefined) {
                var surfixCode = code.split('-').length > 1 ? ('-' + code.split('-')[1]) : '';
                var route = JSON.parse(strRoute);
                route.Filters = {
                    FieldName: code.split('-')[0],
                    Value: title + surfixCode
                }
                route.IsPBSReport = true;
                route.Action = "GatewayActionFormView";
                RecordPopupControl.Hide()
                DevExCtrl.LoadingPanel.Show(GlobalLoadingPanel);
                RecordPopupControl.PerformCallback({ strRoute: JSON.stringify(route) });
            }
        }
    }

    var _btnSubmitMultiGateway = function (s, e, strRoute) {
        var multiGatewayCtrl = ASPxClientControl.GetControlCollection().GetByName("MultiGatewayComboBox");
        if (multiGatewayCtrl != undefined && multiGatewayCtrl != null) {
            var code = multiGatewayCtrl.GetValue();
            var title = multiGatewayCtrl.GetText();
            if (code != "" && code != undefined) {
                var route = JSON.parse(strRoute);
                route.Filters = {
                    FieldName: code,
                    Value: title
                }
                route.IsPBSReport = true;
                route.Action = "FormView";
                RecordPopupControl.Hide()
                DevExCtrl.LoadingPanel.Show(GlobalLoadingPanel);
                RecordPopupControl.PerformCallback({ strRoute: JSON.stringify(route) });
            }
        }
    }

    return {
        ActionDropDownChange: _actionDropDownChange,
        SubActionDropDownChange: _subActionDropDownChange,
        BtnSubmitActionGateway: _btnSubmitActionGateway,
        BtnSubmitMultiGateway: _btnSubmitMultiGateway
    }
})();