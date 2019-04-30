using M4PL.Web.Tests.Common;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System;
using System.IO;
using System.Threading;

namespace M4PL.Web.Tests.Administration.DeliveryStatus
{
    [TestClass]
    public class DeliveryStatusTest
    {
        ChromeDriver _chromeDriver = new ChromeDriver((Directory.GetParent((Directory.GetParent(Environment.CurrentDirectory)).ToString())).ToString() + @"\Utilities\ExternalFiles");
        LoginTest login = new LoginTest();

        [TestMethod]
        public void Run()
        {
            login.LoginTestRun("diksha", "12345", _chromeDriver);
            Add(_chromeDriver, "testCode", "test title", DeliveryStatusXPath.StatusDDOptionOk, DeliveryStatusXPath.SeverityDDOptionMedium);
            Edit(_chromeDriver, "testCode", "test updated title");
        }

        public static void NavigateToPage(ChromeDriver driver)
        {
            Thread.Sleep(4000);
            driver.FindElementById(LeftPanelXPath.DelvrySt).Click();
            Thread.Sleep(10000);
        }

        public static void ToggleFilterFirstRecord(ChromeDriver driver, string searchCode)
        {
            driver.FindElementById(RibbonXPath.ToggleFilter).Click();
            Thread.Sleep(2000);
            driver.FindElementById(DeliveryStatusXPath.ToggleFilterHeaderTextBoxCode).SendKeys(searchCode);
            Thread.Sleep(2000);
        }

        public static void Add(ChromeDriver driver, string code, string title, string statusType, string severityType)
        {
            NavigateToPage(driver);

            driver.FindElementById(RibbonXPath.New).Click();
            Thread.Sleep(15000);

            driver.FindElementById(DeliveryStatusXPath.Code).SendKeys(code);
            Thread.Sleep(1000);

            driver.FindElementById(DeliveryStatusXPath.Title).SendKeys(title);
            Thread.Sleep(1000);

            driver.FindElementById(DeliveryStatusXPath.StatusDDIcon).Click();
            Thread.Sleep(2000);

            driver.FindElementById(statusType).Click();
            Thread.Sleep(2000);

            driver.FindElementById(DeliveryStatusXPath.SeverityDDIcon).Click();
            Thread.Sleep(2000);

            driver.FindElementById(severityType).Click();
            Thread.Sleep(2000);

            driver.FindElementById(DeliveryStatusXPath.Save).Click();
            Thread.Sleep(12000);

            driver.FindElementById(DeliveryStatusXPath.ConfirmationOk).Click();
            Thread.Sleep(12000);
        }

        public static void Edit(ChromeDriver driver, string searchCode, string title)
        {
            NavigateToPage(driver);
            ToggleFilterFirstRecord(driver, searchCode);
            new OpenQA.Selenium.Interactions.Actions(driver).ContextClick(driver.FindElement(By.Id(DeliveryStatusXPath.GridData))).Perform();
            Thread.Sleep(3000);
            driver.FindElementById(DeliveryStatusXPath.Edit).Click();
            Thread.Sleep(2000);
            driver.FindElementById(DeliveryStatusXPath.Title).SendKeys(title);
            Thread.Sleep(1000);
            driver.FindElementById(DeliveryStatusXPath.Save).Click();
            Thread.Sleep(12000);
            driver.FindElementById(DeliveryStatusXPath.ConfirmationOk).Click();
            Thread.Sleep(12000);
        }
    }
}
