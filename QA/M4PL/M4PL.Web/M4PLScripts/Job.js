$(function () {
});

var M4PLJob = M4PLJob || {};
M4PLJob.FormView = function () {
    var _clearErrorMessages = function () {
        $('.popupErrorMessages, .errorMessages').html('');
    };

    _onAddOrEdit = function (s, form, strRoute, loadingPanelControl) {

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

        DevExCtrl.LoadingPanel.Show(loadingPanelControl);
        var putOrPostData = $(form).serializeArray();
        putOrPostData.push({ name: "UserDateTime", value: moment.now() });

        _clearErrorMessages();

        //To update FormViewHasChanges values
        M4PLCommon.Control.UpdateFormViewHasChangesWithDefaultValue();

        if (putOrPostData && putOrPostData.length > 0) {
            $.ajax({
                type: "POST",
                url: $(form).attr("action"),
                data: putOrPostData,
                success: function (response) {
                    var isFromConfirmSave = M4PLWindow.IsFromConfirmSaveClick;
                    M4PLWindow.IsFromConfirmSaveClick = false;
                    if (response && response.status && response.status === true) {
                        if (response.byteArray && response.byteArray.length > 0 && response.route) {
                            M4PLCommon.RichEdit.RichEditorsPerformCallBack(response.route, response.byteArray);
                        }
                        var route = JSON.parse(strRoute);
                        route.RecordId = response.route.RecordId;
                        if (ASPxClientControl.GetControlCollection().GetByName(route.OwnerCbPanel) && !ASPxClientControl.GetControlCollection().GetByName(route.OwnerCbPanel).InCallback()) {
                            if (!isFromConfirmSave) {
                                window.setTimeout(function () {

                                    if (response.refreshContent === true || response.route.Entity !== "Job") {
                                        ASPxClientControl.GetControlCollection().GetByName(route.OwnerCbPanel).PerformCallback({ strRoute: JSON.stringify(route) });
                                    }

                                    if (ASPxClientControl.GetControlCollection().GetByName("JobDeliveryDateTimeActual") && response.record.JobDeliveryDateTimeActual != null)
                                        ASPxClientControl.GetControlCollection().GetByName("JobDeliveryDateTimeActual").SetValue(FromJsonToDate(response.record.JobDeliveryDateTimeActual));
                                    if (ASPxClientControl.GetControlCollection().GetByName("JobOriginDateTimeActual") && response.record.JobOriginDateTimeActual != null)
                                        ASPxClientControl.GetControlCollection().GetByName("JobOriginDateTimeActual").SetValue(FromJsonToDate(response.record.JobOriginDateTimeActual));


                                    if (ASPxClientControl.GetControlCollection().GetByName("DateChanged") && response.record.DateChanged != null)
                                        ASPxClientControl.GetControlCollection().GetByName("DateChanged").SetValue(FromJsonToDate(response.record.DateChanged));
                                    if (ASPxClientControl.GetControlCollection().GetByName("ChangedBy") && response.record.ChangedBy != null)
                                        ASPxClientControl.GetControlCollection().GetByName("ChangedBy").SetValue(response.record.ChangedBy);

                                    if (response.displayMessage)
                                        DisplayMessageControl.PerformCallback({ strDisplayMessage: JSON.stringify(response.displayMessage) });

                                    DevExCtrl.LoadingPanel.Hide(loadingPanelControl);
                                    DevExCtrl.Ribbon.DoCallBack(route);
                                }, 2000);
                            } else
                                M4PLCommon.CheckHasChanges.RedirectToClickedItem();
                        }
                    }
                    else if (response.errMessages && response.errMessages.length > 0) {
                        for (var i = 0; i < response.errMessages.length; i++)
                            $('.errorMessages').append('<p>* ' + response.errMessages[i] + '</p>');
                        DevExCtrl.LoadingPanel.Hide(loadingPanelControl);
                    } else if (response.displayMessage) {
                        DisplayMessageControl.PerformCallback({ strDisplayMessage: JSON.stringify(response.displayMessage) });
                        DevExCtrl.LoadingPanel.Hide(GlobalLoadingPanel);
                    }
                }
            });
        }
    };

    var _setJobOriginDestinationCtrlValues = function (s, e, extnNameOrSuffix, tabNames) {


        var ctrlRealName = s.name.split(extnNameOrSuffix)[0];

        if (ASPxClientControl.GetControlCollection().GetByName(ctrlRealName)) {
            ASPxClientControl.GetControlCollection().GetByName(ctrlRealName).SetValue(s.GetValue());
        }

        $.each(tabNames.split(','), function (k, tabName) {
            if (ASPxClientControl.GetControlCollection().GetByName(ctrlRealName + extnNameOrSuffix + tabName)) {
                ASPxClientControl.GetControlCollection().GetByName(ctrlRealName + extnNameOrSuffix + tabName).SetValue(s.GetValue());
            }
        });


    }

    var _onInitSetJobOriginDestinationCtrlValues = function (s, e, extnNameOrSuffix, tabNames) {
        var ctrlRealName = s.name.split(extnNameOrSuffix)[0];

        $.each(tabNames.split(','), function (k, tabName) {
            if (ASPxClientControl.GetControlCollection().GetByName(ctrlRealName + extnNameOrSuffix + tabName) && ASPxClientControl.GetControlCollection().GetByName(ctrlRealName)) {
                ASPxClientControl.GetControlCollection().GetByName(ctrlRealName + extnNameOrSuffix + tabName).SetValue(ASPxClientControl.GetControlCollection().GetByName(ctrlRealName).GetValue());
            }
        });
    }

    var _mapLoad = function (mapRoute) {
        var mapOptions = {
            center: new google.maps.LatLng(mapRoute.JobLatitude, mapRoute.JobLongitude),
            zoom: 8,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        var infoWindow = new google.maps.InfoWindow();
        var map = new google.maps.Map(document.getElementById("divDestinationMap"), mapOptions);

        var data = markers[i]
        var myLatlng = new google.maps.LatLng(mapRoute.JobLatitude, mapRoute.JobLongitude);
        var marker = new google.maps.Marker({
            position: myLatlng,
            map: map,
            //title: data.title
        });
        (function (marker, mapRoute) {
            google.maps.event.addListener(marker, "click", function (e) {
                //infoWindow.setContent(data.description);
                infoWindow.open(map, marker);
            });
        })(marker, mapRoute);
    }

    var _onGatewayUnitChange = function (s, durationCtrl, dateRefCtrl, ecdCtrl, pcdCtrl, acdCtrl, jsonRecord) {
        var reco = JSON.parse(jsonRecord);
        reco.GwyDateRefTypeId = dateRefCtrl.GetValue();
        $.ajax({
            type: "GET",
            url: "/Job/JobGateway/OnUnitChange?unitType=" + s.GetValue(),
            data: reco,
            success: function (data) {
                if (data.status) {
                    if (data.record.GwyGatewayECD)
                        ecdCtrl.SetValue(FromJsonToDate(data.record.GwyGatewayECD));
                    if (data.record.GwyGatewayPCD)
                        pcdCtrl.SetValue(FromJsonToDate(data.record.GwyGatewayPCD));
                    if (data.record.GwyGatewayACD)
                        acdCtrl.SetValue(FromJsonToDate(data.record.GwyGatewayACD));
                    if (data.record.GwyGatewayDuration)
                        durationCtrl.SetValue(data.record.GwyGatewayDuration);
                }
            }
        });
    }

    var _onGatewayDateRefChange = function (s, unitCtrl, ecdCtrl, pcdCtrl, acdCtrl, jsonRecord) {
        var reco = JSON.parse(jsonRecord);
        reco.GatewayUnitId = unitCtrl.GetValue();
        $.ajax({
            type: "GET",
            url: "/Job/JobGateway/OnDateRefChange?dateRef=" + s.GetValue(),
            data: reco,
            success: function (data) {
                if (data.status) {
                    if (data.record.GwyGatewayECD)
                        ecdCtrl.SetValue(FromJsonToDate(data.record.GwyGatewayECD));
                    if (data.record.GwyGatewayPCD)
                        pcdCtrl.SetValue(FromJsonToDate(data.record.GwyGatewayPCD));
                    if (data.record.GwyGatewayACD)
                        acdCtrl.SetValue(FromJsonToDate(data.record.GwyGatewayACD));
                }
            }
        });
    }

    function FromJsonToDate(value) {
        return new Date(parseInt(value.replace('/Date(', '')));
    }

    var _onCreateJobFromRibbon = function (s, e, route) {
        route.Action = "FormView";
        _doJobCallback(route);
    }

    var _onFormViewJobFromRibbon = function (s, e, route) {
        route.Action = "FormView";
        _doJobCallback(route);
    }

    var _onDataViewJobFromRibbon = function (s, e, route) {
        route.Action = "DataView";
        _doJobCallback(route);
    }

    var _doJobCallback = function (route) {

        var keyValue = TreeList.GetFocusedNodeKey();
        if (route.EntityName == 'Job' && keyValue.indexOf("_") >= 0) {
            keyValue = keyValue.split('_')[1];
            route.IsJobParentEntity = true;
        }

        if (!$.isNumeric(keyValue)) {
            return;
        }

        try {
            route.OwnerCbPanel = "JobDataViewCbPanel"
            route.ParentRecordId = parseInt(keyValue);
            route.ParentEntity = "Program";

            if (JobDataViewCbPanel && !JobDataViewCbPanel.InCallback()) {
                JobDataViewCbPanel.PerformCallback({ strRoute: JSON.stringify(route) });
                DevExCtrl.Ribbon.DoCallBack(route);
            }
        }
        catch (err) {
        }
    }

    var _onGatewayCompleteClick = function (s, e, gridCtrl, recordId, strRoute) {

        var route = JSON.parse(strRoute);
        if (recordId === "") {
            route.recordId = gridCtrl.GetRowKey(gridCtrl.GetFocusedRowIndex());
            route.OwnerCbPanel = gridCtrl.name;
            var rowIndex = gridCtrl.GetFocusedRowIndex();

            if (gridCtrl.batchEditApi.GetColumnIndex("GwyCompleted") !== null) {

                var completed = gridCtrl.batchEditApi.GetCellValue(rowIndex, 'GwyCompleted');
                if (completed === true) {
                    return;
                }
            }

            if (gridCtrl.batchEditApi.GetColumnIndex("GatewayTypeId") !== null) {

                var gatewayType = gridCtrl.batchEditApi.GetCellValue(rowIndex, 'GatewayTypeId');
                if (gatewayType != 85) {
                    return;
                }
            }
        }

        if (RecordPopupControl.IsVisible())
            RecordSubPopupControl.PerformCallback({ strRoute: JSON.stringify(route), strByteArray: "" });
        else
            RecordPopupControl.PerformCallback({ strRoute: JSON.stringify(route), strByteArray: "" });

    }


    var _setJobOriginDestinationCtrlValuesAnsSetWindowTime = function (s, e, extnNameOrSuffix, tabNames, isDay, earlyThresHold, lateThresHold, programTime, stCtrl, endCtrl) {



        _setJobOriginDestinationCtrlValues(s, e, extnNameOrSuffix, tabNames);

        //SET WindowTime;

        var plannedDate = moment(s.GetDate());
        if (s.GetTimeEdit().GetValue() == null) {
            var pt = moment(programTime);
            var minus = pt.hour() * 60 + pt.minute();
            plannedDate.add(minus, 'minutes');
            s.SetValue(plannedDate._d);
        }

        if (isDay === "True") {

            var elTime1 = moment(new Date(plannedDate));
            var ltTime1 = moment(new Date(plannedDate));

            stCtrl.SetValue(elTime1.add(-1, 'days')._d);
            endCtrl.SetValue(ltTime1.add(1, 'days')._d);
        } else {

            var earlyMins = earlyThresHold * 60;
            var lateMins = lateThresHold * 60;

            var elTime = moment(new Date(plannedDate));
            var ltTime = moment(new Date(plannedDate));
            stCtrl.SetValue(elTime.add(earlyMins, 'minutes')._d);
            endCtrl.SetValue(ltTime.add(lateMins, 'minutes')._d);
        }
    }


    return {
        OnAddOrEdit: _onAddOrEdit,
        SetJobOriginDestinationCtrlValues: _setJobOriginDestinationCtrlValues,
        OnInitSetJobOriginDestinationCtrlValues: _onInitSetJobOriginDestinationCtrlValues,
        MapLoad: _mapLoad,
        OnGatewayUnitChange: _onGatewayUnitChange,
        OnGatewayDateRefChange: _onGatewayDateRefChange,
        CreateJobFromRibbon: _onCreateJobFromRibbon,
        FormViewJobFromRibbon: _onFormViewJobFromRibbon,
        DataViewJobFromRibbon: _onDataViewJobFromRibbon,
        OnGatewayCompleteClick: _onGatewayCompleteClick,
        SetJobOriginDestinationCtrlValuesAnsSetWindowTime: _setJobOriginDestinationCtrlValuesAnsSetWindowTime
    }
}();

function MapLoad(mapRoute) {
    var mapOptions = {
        center: new google.maps.LatLng(mapRoute.JobLatitude, mapRoute.JobLongitude),
        zoom: 8,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    var infoWindow = new google.maps.InfoWindow();
    var map = new google.maps.Map(document.getElementById("divDestinationMap"), mapOptions);

    var data = markers[i]
    var myLatlng = new google.maps.LatLng(mapRoute.JobLatitude, mapRoute.JobLongitude);
    var marker = new google.maps.Marker({
        position: myLatlng,
        map: map,
        //title: data.title
    });
    (function (marker, mapRoute) {
        google.maps.event.addListener(marker, "click", function (e) {
            //infoWindow.setContent(data.description);
            infoWindow.open(map, marker);
        });
    })(marker, mapRoute);
}