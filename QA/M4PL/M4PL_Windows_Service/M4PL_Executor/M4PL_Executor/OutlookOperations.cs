using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using MyOutlook = Microsoft.Office.Interop.Outlook;
using RestSharp;
using System.Threading.Tasks;

namespace M4PL_Executor
{
    public class OutlookOperations
    {
        public static void SyncContacts(string authToken, string addContactBaseUrl, int statusIdToAssign)
        {
            try
            {
                //MyOutlook.Application outlook = null;
                if (Process.GetProcessesByName("OUTLOOK").Count() > 0)
                {
                    // If so, use the GetActiveObject method to obtain the process and cast it to an Application object.
                    //outlook = Marshal.GetActiveObject("Outlook.Application") as MyOutlook.Application;
                    WriteToFile("In GetAllContact() method outlook is already running");

                    //--> Killing all the available processes
                    foreach (var process in Process.GetProcessesByName("OUTLOOK"))
                        process.Kill();

                    //return;
                }
                //else
                //{
                WriteToFile("In GetAllContact() method outlook is not running and creating new instance");
                MyOutlook.Application outlook = new MyOutlook.Application();
                //}
                WriteToFile("In GetAllContact() method outlook instance created");

                // get nameSpace and logon.
                MyOutlook.NameSpace olNameSpace = outlook.GetNamespace("mapi");
                olNameSpace.Logon("Outlook", "", false, true);

                WriteToFile("In GetAllContact() method outlook instance created and given logons");
                // get the contact items
                MyOutlook.MAPIFolder _olContacts = olNameSpace.GetDefaultFolder(MyOutlook.OlDefaultFolders.olFolderContacts);
                MyOutlook.Items olItems = _olContacts.Items;

                foreach (object currentItem in olItems)
                {
                    if (currentItem is MyOutlook.ContactItem)
                    {
                        MyOutlook.ContactItem contact = (MyOutlook.ContactItem)currentItem;

                        Contact currentContact = new Contact
                        {
                            ConCompany = contact.CompanyName,
                            ConTitle = contact.Title,
                            ConLastName = contact.LastName,
                            ConFirstName = contact.FirstName,
                            ConMiddleName = contact.MiddleName,
                            //ConEmailAddress = contact.Email1Address,
                            //ConEmailAddress2 = contact.Email2Address,
                            ConJobTitle = contact.JobTitle,
                            ConBusinessPhone = contact.BusinessTelephoneNumber,
                            ConHomePhone = contact.HomeTelephoneNumber,
                            ConMobilePhone = contact.MobileTelephoneNumber,
                            ConFaxNumber = contact.BusinessFaxNumber,
                            ConBusinessAddress1 = contact.BusinessAddress,
                            ConBusinessCity = contact.BusinessAddressCity,
                            ConBusinessStateIdName = contact.BusinessAddressState,
                            ConBusinessZipPostal = contact.BusinessAddressPostalCode,
                            ConBusinessCountryIdName = contact.BusinessAddressCountry,
                            ConHomeAddress1 = contact.HomeAddress,
                            ConHomeCity = contact.HomeAddressCity,
                            ConHomeStateIdName = contact.HomeAddressState,
                            ConHomeZipPostal = contact.HomeAddressPostalCode,
                            ConHomeCountryIdName = contact.HomeAddressCountry,
                            ConWebPage = contact.WebPage,
                            //ConNotes = contact.Body,
                            StatusId = statusIdToAssign
                        };
                        new Task(() => { SaveContact(currentContact, authToken, addContactBaseUrl); }).Start();
                    }
                }
            }
            catch (Exception ex)
            {
                WriteToFile("Got Exception in GetAllContact() -> " + ex.Message);
            }
        }

        private static void WriteToFile(string text)
        {
            string path = "C:\\test\\M4PL_Executor.txt";
            using (StreamWriter writer = new StreamWriter(path, true))
            {
                writer.WriteLine(text);
                writer.Close();
            }
        }

        private List<string> ContactProperties()
        {
            return new List<string>
            {
                "CompanyName",
                "Title",
                "LastName",
                "FirstName",
                "MiddleName",
                "Email1Address",
                "Email2Address",
                "JobTitle",
                "BusinessTelephoneNumber",
                "HomeTelephoneNumber",
                "MobileTelephoneNumber",
                "BusinessFaxNumber",
                "BusinessAddress",
                "BusinessAddressState",
                "BusinessAddressPostalCode",
                "BusinessAddressCountry",
                "HomeAddress",
                "HomeAddressCity",
                "HomeAddressState",
                "HomeAddressPostalCode",
                "HomeAddressCountry",
                "WebPage",
                "Body",
            };
        }

        public static void SaveContact(Contact contact, string authToken, string addContactBaseUrl)
        {
            try
            {
                WriteToFile("Inside SaveContact()");
                var restClient = new RestClient(new Uri(addContactBaseUrl));
                var request = new RestRequest("Contacts", Method.POST) { RequestFormat = DataFormat.Json };
                request.AddHeader("Content-Type", "application/json; charset=utf-8");
                request.AddHeader("Authorization", "bearer " + authToken);
                request.OnBeforeDeserialization = resp =>
                {
                    resp.ContentType = "application/json";
                    resp.Content = resp.Content.Replace("[]", "{}");
                };
                restClient.Execute(request.AddObject(contact));
            }
            catch (Exception ex)
            {
                WriteToFile("Got Exception in SaveContact() -> " + ex.Message);
            }
        }

    }

    public class OutlookArguments
    {
        public string AuthToken { get; set; }
        public string AddContactBaseUrl { get; set; }
        public int StatusIdToAssign { get; set; }
    }
}
