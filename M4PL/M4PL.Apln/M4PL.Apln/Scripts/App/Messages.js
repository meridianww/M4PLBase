var msg = '@Model.Message';
var msgType = '@Model.MessageType';

$(window).load(function () {
    if (msg != null && msg.length > 0) {
        if (msgType === "Success" || msgType === 1) $('#btnSuccess').click();
        else if (msgType === "Failure" || msgType === 2) $('#btnError').click();
        else if (msgType === "Failure" || msgType === 2) $('#deletecol').click();
        else $('#btnInfo').click();
    }
});