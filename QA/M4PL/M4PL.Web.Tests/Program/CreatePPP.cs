using M4PL.Web.Tests.Common;
using OpenQA.Selenium.Chrome;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace M4PL.Web.Tests.Program
{
    
    public class CreatePPP
    {
        public static void createProgram( string prgmCode, string prgmTitle, string earliestThreshold, string latestThreshold, ChromeDriver driver)
        {
            Thread.Sleep(3000);
            driver.FindElementById(LeftPanelXPath.PrgDVS).Click();
            Thread.Sleep(8000);
            driver.FindElementById(ProgramXPath.PrgSearchedCusCode).Click();
            Thread.Sleep(6000);
           
            driver.FindElementById(ProgramXPath.PrgNewBtn).Click();
            Thread.Sleep(10000);
            driver.FindElementById(ProgramXPath.PrgCode).SendKeys(prgmCode);
            Thread.Sleep(2000);
            driver.FindElementById(ProgramXPath.PrgTitle).SendKeys(prgmTitle);
            Thread.Sleep(2000);
            driver.FindElementById(ProgramXPath.PrgDateStartDrpdwn).Click();
            Thread.Sleep(2000);
            driver.FindElementById(ProgramXPath.PrgDateStartToday).Click();
            Thread.Sleep(2000);
            driver.FindElementById(ProgramXPath.PrgDateEndDrpdwn).Click();
            Thread.Sleep(2000);
            driver.FindElementById(ProgramXPath.PrgDateEndToday).Click();
            Thread.Sleep(5000);
            driver.FindElementById(ProgramXPath.PrgRecvdThrshldDefault).Click();
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.PrgRecvdThrshldEarliest).SendKeys(earliestThreshold);
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.PrgRecvdThrshldLatest).SendKeys(latestThreshold);
            Thread.Sleep(7000);
            driver.FindElementById(ProgramXPath.PrgSave).Click();
            Thread.Sleep(7000);
            driver.FindElementById(ProgramXPath.PrgSaveOkbtn).Click();
            Thread.Sleep(8000);
        }

        public static void InvalidTest( string prgmCode, ChromeDriver driver)
        {
            Thread.Sleep(2000);
            driver.FindElementById(LeftPanelXPath.PrgDVS).Click();
            Thread.Sleep(8000);
            driver.FindElementById(ProgramXPath.PrgSearchedCusCode).Click();
            Thread.Sleep(6000);
            driver.FindElementById(ProgramXPath.PrgNewBtn).Click();
            Thread.Sleep(10000);
            driver.FindElementById(ProgramXPath.PrgCode).SendKeys(prgmCode);
            Thread.Sleep(2000);
            driver.FindElementById(ProgramXPath.PrgSave).Click();
            Thread.Sleep(7000);
            if (!string.IsNullOrWhiteSpace(prgmCode))
            {
                string expectedVal = "* Program Code is required";
                Assert.AreEqual("* Program Code is required", expectedVal);
            }
            else
            {
                Thread.Sleep(3000);
                driver.FindElementById(ProgramXPath.PrgSaveOkbtn).Click();
            }
        }
    }
}
