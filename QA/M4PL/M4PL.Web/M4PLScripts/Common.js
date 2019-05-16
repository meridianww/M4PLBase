﻿/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 Commom.js
//Purpose:                                      For implementing common client side logic throughout the application
//====================================================================================================================================================*/

$(function () {
    M4PLCommon.ContactCombobox.init();
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

    return {
        init: init,
        SwitchOrganization: _switchOrganization,
        GetLookupIdByName: _getLookupIdByName,
        OnCallbackError: _onCallbackError,
        OnThemeChange: _onThemeChange,
        GetParameterValueFromRoute: _routeParameterValue,
        ReloadApplication: _reloadApplication,
        LogOut: _onLogOut

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

    var _richEditorsPerformCallBack = function (route, byteArray) {
        $.each(byteArray, function (index, value) {
            if (ASPxClientControl.GetControlCollection().GetByName(value.ControlName)) {
                M4PLCommon.CurrentByteArrayCount += 1;
                ASPxClientControl.GetControlCollection().GetByName(value.ControlName).callbackCustomArgs["ByteArrayRecordId"] = route.RecordId;//same callbackCustomArgs name as WebApplicationConstants.ByteArrayRecordId
                ASPxClientControl.GetControlCollection().GetByName(value.ControlName).PerformCallback({ strByteArray: JSON.stringify(value) });
            }
        });
    }

    var _onEndCallBack = function (s, e) {
        M4PLCommon.CurrentByteArrayCount -= 1;
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
            //For TextBox
            if (currentControl.GetChildElement('I')) {
                var textComponent = document.getElementById($(currentControl.GetChildElement('I')).attr('id'));
                if (textComponent.selectionStart !== undefined) {
                    // Standards Compliant Version 
                    var startPos = textComponent.selectionStart;
                    var endPos = textComponent.selectionEnd;
                    var currentValue = textComponent.value;
                    if (currentControl.GetText() != "")
                        currentControl.SetText(textComponent.value.substring(0, startPos) + localStorage.getItem("CopiedText") + textComponent.value.substring(endPos, textComponent.value.length));
                    else
                        currentControl.SetText(localStorage.getItem("CopiedText"));
                    textComponent.focus();
                }
                else if (document.selection !== undefined) {
                    // IE Version
                    textComponent.focus();
                    var sel = document.selection.createRange();
                }
            }
            //For RichTextBox
            if (currentControl.selection && currentControl.document) {
                currentControl.commands.insertText.execute(localStorage.getItem("CopiedText"));
                currentControl.Focus();
            }
        }
    }

    var _onTextChanged = function () {
        if (ASPxClientControl.GetControlCollection().GetByName('RecordSubPopupControl') && ASPxClientControl.GetControlCollection().GetByName('RecordSubPopupControl').IsVisible())
            M4PLWindow.SubPopupFormViewHasChanges = true;
        else if (ASPxClientControl.GetControlCollection().GetByName('RecordPopupControl') && ASPxClientControl.GetControlCollection().GetByName('RecordPopupControl').IsVisible())
            M4PLWindow.PopupFormViewHasChanges = true;
        else
            M4PLWindow.FormViewHasChanges = true;
    }

    var _updateDataViewHasChanges = function (dataViewName, currentStatus) {
        if (ASPxClientControl.GetControlCollection().GetByName('RecordPopupControl') && ASPxClientControl.GetControlCollection().GetByName('RecordPopupControl').IsVisible())
            M4PLWindow.PopupDataViewHasChanges[dataViewName] = currentStatus;
        else if ($('div[id^="btn"][id$="Save"]').length > 0)
            M4PLWindow.SubDataViewsHaveChanges[dataViewName] = currentStatus;
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
                            M4PLWindow.DataView.SetCustomButtomVisibility(currentGrid, null);
                        }
                    }
                }
                M4PLWindow.SubDataViewsHaveChanges = {};
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
                        M4PLCommon.RichEdit.RichEditorsPerformCallBack(response.route, response.byteArray);
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