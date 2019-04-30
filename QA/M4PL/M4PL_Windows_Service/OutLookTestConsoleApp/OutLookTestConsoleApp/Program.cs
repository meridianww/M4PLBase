using System;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using Outlook = Microsoft.Office.Interop.Outlook;

namespace OutLookTestConsoleApp
{
    class Program
    {
        static void Main(string[] args)
        {
            GetAllContact();
            //var outlookApp = GetApplicationObject();
            //Console.WriteLine("test");
            //Console.ReadKey();
        }

        /*
        static Outlook.Application GetApplicationObject()
        {

            Outlook.Application application = null;

            // Check whether there is an Outlook process running.
            if (Process.GetProcessesByName("OUTLOOK").Count() > 0)
            {

                // If so, use the GetActiveObject method to obtain the process and cast it to an Application object.
                application = Marshal.GetActiveObject("Outlook.Application") as Outlook.Application;
            }
            else
            {

                // If not, create a new instance of Outlook and log on to the default profile.
                application = new Outlook.Application();
                Outlook.NameSpace nameSpace = application.GetNamespace("MAPI");
                nameSpace.Logon("", "", Missing.Value, Missing.Value);
                nameSpace = null;
            }

            // Return the Outlook Application object.
            return application;
        }
        */

        public static void GetAllContact()
        {
            try
            {
                Process[] processes = Process.GetProcessesByName("OUTLOOK");


                if (Process.GetProcessesByName("OUTLOOK").Count() > 0)
                {
                    // If so, use the GetActiveObject method to obtain the process and cast it to an Application object.
                    //outlook = Marshal.GetActiveObject("Outlook.Application") as MyOutlook.Application;
                    WriteToFile("In GetAllContact() method outlook is already running");

                    foreach (var process in Process.GetProcessesByName("OUTLOOK"))
                        process.Kill();

                    //return;
                }
                Outlook.Application outlook = new Outlook.Application();

                //Outlook.Application outlook = (processes.Length != 0) ? Marshal.GetActiveObject("Outlook.Application") as Outlook.Application : new Outlook.Application();


                //Outlook.Application outlook = Marshal.GetActiveObject("Outlook.Application") as Outlook.Application;
                //Outlook.Application outlook = new Outlook.Application();

                // get nameSpace and logon.
                Outlook.NameSpace olNameSpace = outlook.GetNamespace("mapi");
                olNameSpace.Logon("Outlook", "", false, true);

                //// get the contact items
                Outlook.MAPIFolder _olContacts = olNameSpace.GetDefaultFolder(Outlook.OlDefaultFolders.olFolderContacts);
                Outlook.Items olItems = _olContacts.Items;

                //Outlook.MAPIFolder contactsFolder = outlook.GetNamespace("MAPI").GetDefaultFolder(Outlook.OlDefaultFolders.olFolderContacts);
                //Outlook.Items contactItems = contactsFolder.Items;

                //Outlook.ContactItem contact =
                //    (Outlook.ContactItem)contactItems.
                //    Find(String.Format("[FirstName]='{0}' and "
                //    + "[LastName]='{1}'", firstName, lastName));
                //if (contact != null)
                //{
                //    contact.Display(true);
                //}
                //else
                //{
                //    //MessageBox.Show("The contact information was not found.");
                //}
                foreach (object currentItem in olItems)
                {
                    if (currentItem is Outlook.ContactItem)
                    {
                        Outlook.ContactItem contact = (Outlook.ContactItem)currentItem;
                        var column1 = contact.CompanyName;
                        var column2 = contact.Title;
                        var column3 = contact.LastName;
                        var column4 = contact.FirstName;
                        var column5 = contact.MiddleName;
                        //var column6 = contact.Email1Address;
                        //var column7 = contact.Email2Address;
                        var column9 = contact.JobTitle;
                        var column10 = contact.BusinessTelephoneNumber;
                        var column11 = contact.HomeTelephoneNumber;
                        var column12 = contact.MobileTelephoneNumber;
                        var column13 = contact.BusinessFaxNumber;
                        var column14 = contact.BusinessAddress;
                        var column15 = contact.BusinessAddressState;
                        var column16 = contact.BusinessAddressPostalCode;
                        var column17 = contact.BusinessAddressCountry;
                        var column18 = contact.HomeAddress;
                        var column19 = contact.HomeAddressCity;
                        var column20 = contact.HomeAddressState;
                        var column21 = contact.HomeAddressPostalCode;
                        var column22 = contact.HomeAddressCountry;
                        var column23 = contact.WebPage;
                        var column24 = contact.Body;

                        //foreach (Outlook.ItemProperty property in contact.ItemProperties)
                        //{
                        //    WriteToFile(property.Name + ": " + property.Value.ToString());
                        //}
                    }

                    //var lastName = currentItem.LastName;
                    //var firstName = currentItem.FirstName;
                    //var mobileNumber = currentItem.MobileTelephoneNumber;
                    //var email = currentItem.Email1Address;
                    //WriteToFile(currentItem.LastName);
                    //WriteToFile(currentItem.FirstName);
                    //WriteToFile(currentItem.MobileTelephoneNumber);
                    //WriteToFile(currentItem.Email1Address);

                }
            }
            catch (Exception ex)
            {
                WriteToFile("Got Exception -> " + ex.Message);
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
    }
}
