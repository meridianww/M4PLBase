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
{
    [TestClass]
    public class PrgGatewayTest
    {
        ChromeDriver _chromeDriver = new ChromeDriver((Directory.GetParent((Directory.GetParent(Environment.CurrentDirectory)).ToString())).ToString() + @"\Utilities\ExternalFiles");


        [TestMethod]
        public void Run()
        {
            LoginTest.loginToApplication("diksha", "12345", _chromeDriver);
            ProgramTest.NavigateToProgramDVS(_chromeDriver);
            ProgramTest.SearchedProgram(_chromeDriver);
            //ProgramTest.NewIconClick(_chromeDriver);
            PrgGateway.Add("GTWY_82ND", 83, _chromeDriver);
        }
    }
}

