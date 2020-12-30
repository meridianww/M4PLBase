
$(function () {
    var jobNotifier = $.connection.jobNotifier;

    $.extend(jobNotifier.client, {
        notifyJobForm: function (jobId) {
            alert(jobId);

        }
    });

    $.connection.hub.start().done(function () {
    }
    );

});