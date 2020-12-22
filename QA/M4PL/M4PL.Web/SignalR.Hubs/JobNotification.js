
$(function () {
    var jobNotifier = $.connection.jobNotifier;

    $.extend(jobNotifier.client, {
        notifyJobForm: function (jobId) {
            window.alert(jobId);
            if (jobId === $('#Id').val()) {
                ASPxClientControl.GetControlCollection().GetByName('JobDataViewCbPanel').PerformCallback({ strRoute: $('#hdnRoute').val(), gridName: '', isDataView: false })
            }
        }
    });

    $.connection.hub.start().done(function () {
    }
    );
});