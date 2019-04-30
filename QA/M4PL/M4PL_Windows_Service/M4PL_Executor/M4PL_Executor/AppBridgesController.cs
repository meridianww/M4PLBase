using Newtonsoft.Json;
using System;
using System.IO;
using System.Web.Http;
using System.Web.Http.Cors;

namespace M4PL_Executor
{
    [EnableCors(origins: "*", headers: "*", methods: "*")]
    public class AppBridgeController : ApiController
    {
        [HttpGet]
        public bool InitiateAction(Int32 id)
        {
            CustomCommands currentCommand;
            var isAvailable = Enum.TryParse(id.ToString(), out currentCommand);
            if (Enum.TryParse(id.ToString(), out currentCommand))
                return PerformCustomAction(currentCommand, new string[] { });
            return true;
        }

        [HttpGet]
        public bool SyncOutlookContacts(string allArgument)
        {
            var allArguments = JsonConvert.DeserializeObject<OutlookArguments>(allArgument);
            var authToken = allArguments.AuthToken;
            var addContactBaseUrl = allArguments.AddContactBaseUrl;
            var statusIdToAssign = allArguments.StatusIdToAssign;
            WriteToFile("inside SyncOutlookContacts() method and parameters are: authToke:" + authToken + " & baseUrl:" + addContactBaseUrl + " & statusIdToAssign:" + statusIdToAssign);
            if (Type.GetTypeFromProgID("Outlook.Application") != null)
            {
                OutlookOperations.SyncContacts(authToken, addContactBaseUrl, statusIdToAssign);
                return true;
            }
            return false;
        }

        private bool PerformCustomAction(CustomCommands customCommand, string[] extraParameters)
        {
            string applicationName = string.Empty;
            switch (customCommand)
            {
                case CustomCommands.Notepad:
                    applicationName = "notepad.exe";
                    break;
                case CustomCommands.Calc:
                    applicationName = "calc.exe";
                    break;
                case CustomCommands.Skype:
                    return CheckAppRegistry.IsSoftwareInstalled("Skype", null);
                case CustomCommands.Outlook:
                    return (Type.GetTypeFromProgID("Outlook.Application") != null);
            }

            if (!string.IsNullOrWhiteSpace(applicationName))
            {
                ApplicationLoader.PROCESS_INFORMATION procInfo;
                ApplicationLoader.StartProcessAndBypassUAC(applicationName, out procInfo);
            }
            return true;
        }

        public enum CustomCommands
        {
            Notepad = 128,
            Calc = 240,
            Skype = 233,
            Outlook = 235,
        }

        private void WriteToFile(string text)
        {
            string path = "C:\\test\\M4PL_Executor.txt";
            using (StreamWriter writer = new StreamWriter(path, true))
            {
                writer.WriteLine(text);
                writer.Close();
            }
        }

    }
}
