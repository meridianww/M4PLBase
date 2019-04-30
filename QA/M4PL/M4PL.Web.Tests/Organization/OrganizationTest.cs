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
    public class OrganizationTest
    {

        ChromeDriver _chromeDriver = new ChromeDriver((Directory.GetParent((Directory.GetParent(Environment.CurrentDirectory)).ToString())).ToString() + @"\Utilities\ExternalFiles");
        LoginTest login = new LoginTest();

        [TestMethod]
        public void Run()
        {
            LoginTest.loginToApplication("diksha", "12345", _chromeDriver);
            CreateOrganizationandDetails.Add("OrgCD.11", "ORG_TITLE", _chromeDriver);
            OrgCreatePOC.AddPOC("POC_Code", "POC_Title", "ABf", "D", "Abfwd@mailinator.com", _chromeDriver);
            OrgCreateCredentials.createOrgCredDetails("Cred_CDE", "Cred_Title", _chromeDriver);
            OrgCreateCredentials.editOrgCredDetails(_chromeDriver);
            //OrgEditRoles_RespDetails.editRolesRespDetails(_chromeDriver);
            ScreensControls.updateOrgDetail(_chromeDriver);
        }
    }
}