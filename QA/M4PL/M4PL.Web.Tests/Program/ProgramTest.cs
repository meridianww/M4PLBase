using M4PL.Web.Tests.Common;
using M4PL.Web.Tests.Program;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OpenQA.Selenium.Chrome;
using System;
using System.IO;
using System.Linq;
using System.Threading;
using System.Xml.Linq;

namespace M4PL.Web.Tests.Organization
{

    [TestClass]
    public class ProgramTest
    {

        ChromeDriver _chromeDriver = new ChromeDriver((Directory.GetParent((Directory.GetParent(Environment.CurrentDirectory)).ToString())).ToString() + @"\Utilities\ExternalFiles");
        //LoginTest login = new LoginTest();

        [TestMethod]
        public void Run()
        {
            LoginTest.loginToApplication("diksha", "12345", _chromeDriver);
            //InvalidTest("", _chromeDriver);
            //PPP("PRGMCDE", "PRJCDE", "PHSCDE", "Prg Automated", "-4", "3", _chromeDriver);
            Add("PRGMCDE1", "PRJCDE1", "PHSCDE1", "Prg Automated", "-4", "3", ProgramXPath.PrgSearchedCusCode, _chromeDriver);




        }

        public static void Add(string PrgmCode, string PrjCode, string PhsCode, string PrgmTitle, string EarliestThreshold, string LatestThreshold, string currentSearchedCusCode, ChromeDriver driver)
        {
            if (currentSearchedCusCode.Count(x => x == '_') == 1)
            {
                Thread.Sleep(3000);
                driver.FindElementById(LeftPanelXPath.PrgDVS).Click();
                Thread.Sleep(8000);
                driver.FindElementById(currentSearchedCusCode).Click();
                Thread.Sleep(6000);
            }
            driver.FindElementById(ProgramXPath.PrgNewBtn).Click();
            Thread.Sleep(10000);
            driver.FindElementById(ProgramXPath.PrgCode).SendKeys(PrgmCode);
            if (currentSearchedCusCode.Count(x => x == '_') == 2)
                driver.FindElementById(ProgramXPath.ProjectCode).SendKeys(PrjCode);
            if (currentSearchedCusCode.Count(x => x == '_') == 3)
                driver.FindElementById(ProgramXPath.PhaseCode).SendKeys(PhsCode);
            Thread.Sleep(2000);
            driver.FindElementById(ProgramXPath.PrgTitle).SendKeys(PrgmTitle);
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
            driver.FindElementById(ProgramXPath.PrgRecvdThrshldEarliest).SendKeys(EarliestThreshold);
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.PrgRecvdThrshldLatest).SendKeys(LatestThreshold);
            Thread.Sleep(7000);

            driver.FindElementById(ProgramXPath.PrgSave).Click();
            Thread.Sleep(8000);
            driver.FindElementById(ProgramXPath.PrgSaveOkbtn).Click();
            Thread.Sleep(10000);
            if (currentSearchedCusCode.Count(x => x == '_') < 3)
                Add(PrgmCode, PrjCode, PhsCode, PrgmTitle, EarliestThreshold, LatestThreshold, string.Format("{0}_0", currentSearchedCusCode), driver);
        }
        public static void InvalidTest(string prgmCode, ChromeDriver driver)
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

            //var previousValues = errorMessages//-> get this div values

            driver.FindElementById(ProgramXPath.PrgSave).Click();
            Thread.Sleep(7000);

            var errorMsgs = driver.FindElementByClassName("errorMessages").Text;


            System.Diagnostics.Debug.WriteLine(!string.IsNullOrWhiteSpace(errorMsgs) ? errorMsgs : "Succeeded");
        }

        public static void PPP(string PrgmCode, string PrjCode, string PhsCode, string PrgmTitle, string EarliestThreshold, string LatestThreshold, ChromeDriver driver)
        {

            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgSearchedCusCode).Click();
            Thread.Sleep(4000);

            driver.FindElementById(ProgramXPath.PrgNewBtn).Click();
            Thread.Sleep(7000);

            driver.FindElementById(ProgramXPath.PrgCode).SendKeys(PrgmCode);
            Thread.Sleep(2000);
            driver.FindElementById(ProgramXPath.PrgTitle).SendKeys(PrgmTitle);
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
            driver.FindElementById(ProgramXPath.PrgRecvdThrshldEarliest).SendKeys(EarliestThreshold);
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.PrgRecvdThrshldLatest).SendKeys(LatestThreshold);
            Thread.Sleep(7000);
            if (!string.IsNullOrWhiteSpace(driver.FindElementById(ProgramXPath.PrgCode).Text))
            {
                Thread.Sleep(2000);
                driver.FindElementById(ProgramXPath.PrgNewBtn).Click();
                Thread.Sleep(2000);
                driver.FindElementById(ProgramXPath.ProjectCode).SendKeys(PrjCode);
                Thread.Sleep(2000);
            }
            else if (!string.IsNullOrWhiteSpace(driver.FindElementById(ProgramXPath.ProjectCode).Text))
            {
                Thread.Sleep(2000);
                driver.FindElementById(ProgramXPath.PrgNewBtn).Click();
                Thread.Sleep(2000);
                driver.FindElementById(ProgramXPath.PhaseCode).SendKeys(PhsCode);
                Thread.Sleep(2000);
            }
            driver.FindElementById(ProgramXPath.PrgSave).Click();
            Thread.Sleep(8000);
            driver.FindElementById(ProgramXPath.PrgSaveOkbtn).Click();
            Thread.Sleep(10000);

        }

        public static void NavigateToProgramDVS(ChromeDriver driver)
        {
            driver.FindElementById(LeftPanelXPath.PrgDVS).Click();
            Thread.Sleep(8000);
        }

        public static void SearchedProgram(ChromeDriver driver)
        {
            driver.FindElementByXPath(ProgramXPath.CusCodeArrow).Click();
            Thread.Sleep(4000);
            driver.FindElementByXPath(ProgramXPath.SearchedProgram).Click();
            Thread.Sleep(5000);
        }

        public static void SearchedProject(ChromeDriver driver)
        {
            driver.FindElementById(ProgramXPath.CusCodeArrow).Click();
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.ProgramCodeArrow).Click();
            Thread.Sleep(5000);
            driver.FindElementById(ProgramXPath.SearchedProject).Click();
            Thread.Sleep(3000);
        }

        public static void SearchedPhase(ChromeDriver driver)
        {
            driver.FindElementById(ProgramXPath.CusCodeArrow).Click();
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.ProgramCodeArrow).Click();
            Thread.Sleep(5000);
            driver.FindElementById(ProgramXPath.ProjectCodeArrow).Click();
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.SearchedPhase).Click();
            Thread.Sleep(3000);
        }

        public static void NewIconClick(ChromeDriver driver)
        {
            driver.FindElementById(ProgramXPath.PrgNewBtn).Click();
            Thread.Sleep(4000);
        }

    }
}

