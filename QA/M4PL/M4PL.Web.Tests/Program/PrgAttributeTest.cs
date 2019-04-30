using M4PL.Web.Tests.Common;
using M4PL.Web.Tests.Organization;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OpenQA.Selenium.Chrome;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Web.Tests.Program
{   [TestClass]
    public class PrgAttributeTest
    {
        ChromeDriver _chromeDriver = new ChromeDriver((Directory.GetParent((Directory.GetParent(Environment.CurrentDirectory)).ToString())).ToString() + @"\Utilities\ExternalFiles");
        

        [TestMethod]
        public void Run()
        {
            LoginTest.loginToApplication("diksha", "12345", _chromeDriver);
           // ProgramTest programTest = new ProgramTest();
            ProgramTest.Add("PRGMCDEA1", "PRJ22M33_ER", "PHS23332J", "Prg Automated", "-4", "3", ProgramXPath.PrgSearchedCusCode, _chromeDriver);
            PrgAttribute.Add("attrb_02", "Shipment Assignment", "34", _chromeDriver);

        }
    }
}
