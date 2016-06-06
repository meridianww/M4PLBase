var msg = '@Model.Message';
var msgType = '@Model.MessageType';

$(window).load(function () {
    if (msg !== null && msg.length > 0) {
        if (msgType === "Success" || msgType === 1) $('#btnSuccess').click();
        else if (msgType === "Failure" || msgType === 2) $('#btnError').click();
        else if (msgType === "Failure" || msgType === 2) $('#btnDelete').click();
        else $('#btnInfo').click();
    }
});



function DisplayMessage(result) {
    var msgType = result.SystemMessages;
    var msg = result.Message;
    if (msg != null && msg.length > 0) {
        if (msgType.SysMsgType === "Success" || msg === 1) {
            $('#divbtnOKCancel').show(); $('#divbtnYesNO').hide();
            $('#divIssuelbl').empty().append('Message');
            $('#divIssue').show();
            $('#divSolution').hide();
        }
        else if (msgType.SysMsgType === "Failure" || msg === 2) {
            $('#divbtnOKCancel').show(); $('#divbtnYesNO').hide();
            $('#divIssue').show();
            $('#divSolution').show();
        }
        else {
            $('#divbtnOKCancel').hide(); $('#divbtnYesNO').show();
            $('#divIssue').show();
            $('#divSolution').hide();
        }
    }
    $('#SysMessageCode1').append(msgType.SysMessageCode);
    $('#SysScreenTitle').append(msgType.sysMessageScreenTitle);
    $('#SysMessageTitle').append(msgType.SysMessageTitle);
    $('#SysMessageDescription').append(msgType.SysMessageDescription);
    $('#SysMessageCode').append(msgType.SysMessageCode);
    $('#SysMessageInstruction').append(msgType.SysMessageInstruction);
    $('#btnmsgbox').click();
}