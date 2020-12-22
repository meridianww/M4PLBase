
$(function () {
    var jobNotifier = $.connection.jobNotifier;

    $.extend(jobNotifier.client, {
        notifyJobForm: function (jobId, client) {
            var clientId = $.connection.hub.id;
            if (jobId === $('#Id').val() && clientId != client) {
                if (ASPxClientControl.GetControlCollection().GetByName('JobDataViewCbPanel') === null) {
                    ASPxClientControl.GetControlCollection().GetByName('AppCbPanel').PerformCallback({ strRoute: $('#hdnRoute').val(), gridName: '', isDataView: false })
                }
                else {
                    ASPxClientControl.GetControlCollection().GetByName('JobDataViewCbPanel').PerformCallback({ strRoute: $('#hdnRoute').val(), gridName: '', isDataView: false })
                }
            }
        }
    });

    $.connection.hub.start().done(function () {
    }
    );
});