using M4PL.Web.Tests.Common;
using M4PL.Web.Tests.Organization;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OpenQA.Selenium.Chrome;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace M4PL.Web.Tests.Program
{
    [TestClass]
    public class PrgGatewayTest
    {
        ChromeDriver _chromeDriver = new ChromeDriver((Directory.GetParent((Directory.GetParent(Environment.CurrentDirectory)).ToString())).ToString() + @"\M4PL.Utilities\ExternalFiles");


        [TestMethod]
        public void Run()
        {
            LoginTest.loginToApplication("nfujimoto", "Password", _chromeDriver);
            ProgramTest.NavigateToProgramDVS(_chromeDriver);
            Thread.Sleep(4000);
            ProgramTest.SearchedProgram(_chromeDriver);
            Thread.Sleep(4000);
            //_chromeDriver.FindElementById("//*[@id='pnlProgramDetail_HC']").Click();
            //_chromeDriver.FindElementById("//*[@id='pnlProgramDelAndPckThreshold_HC']").Click();
            PrgGateway.AddGateway("Test", "Test", _chromeDriver);
            //PrgGateway.Add("GTWY_82ND", 83, _chromeDriver);
        }
    }
}

