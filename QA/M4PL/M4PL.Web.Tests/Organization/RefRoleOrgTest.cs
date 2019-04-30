using M4PL.Web.Tests.Common;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OpenQA.Selenium.Chrome;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Web.Tests.Organization
{
    [TestClass]
    public class RefRoleOrgTest
    {

        ChromeDriver _chromeDriver = new ChromeDriver((System.IO.Directory.GetParent((Directory.GetParent(Environment.CurrentDirectory)).ToString())).ToString() + @"\Utilities\ExternalFiles");
        LoginTest login = new LoginTest();

        [TestMethod]
        public void Run()
        {
            LoginTest.loginToApplication("diksha", "12345", _chromeDriver);
            OrgCreateRefRoles.refRoles("NEWREFR1", "NEWREFR1", "Renee", "Yankee", "Business Executive Manager", "045-532-1813", "reney@mailinator.com", _chromeDriver);
            OrgCreateRefRoles.editRefRoles("NEWREFR1", _chromeDriver);
        }

    }

}
