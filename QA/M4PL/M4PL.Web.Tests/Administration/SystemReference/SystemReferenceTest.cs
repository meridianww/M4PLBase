using M4PL.Web.Tests.Common;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System;
using System.IO;
using System.Threading;

namespace M4PL.Web.Tests.Administration.SystemReference
{
    [TestClass]
    public class SystemReferenceTest
    {
        ChromeDriver _chromeDriver = new ChromeDriver((Directory.GetParent((Directory.GetParent(Environment.CurrentDirectory)).ToString())).ToString() + @"\Utilities\ExternalFiles");
        LoginTest login = new LoginTest();

        [TestMethod]
        public void Run()
        {
            login.LoginTestRun("diksha", "12345", _chromeDriver);
            Add(_chromeDriver, SystemReferenceXPath.LookupCodeDDOptionQuestionType, "TestQuestionTypeOption");
            Edit(_chromeDriver, "TestQuestionTypeOption", "TestUpdatedQuestionTypeOption");
        }

        public static void NavigateToPage(ChromeDriver driver)
        {
            Thread.Sleep(4000);
            driver.FindElementById(LeftPanelXPath.SysRef).Click();
            Thread.Sleep(10000);
        }

        public static void ToggleFilterFirstRecord(ChromeDriver driver, string searchOption)
        {
            driver.FindElementById(RibbonXPath.ToggleFilter).Click();
            Thread.Sleep(2000);
            driver.FindElementById(SystemReferenceXPath.ToggleFilterHeaderTextBoxOptionName).SendKeys(searchOption);
            Thread.Sleep(2000);
        }

        public static void Add(ChromeDriver driver, string lookupCode, string optionName)
        {
            NavigateToPage(driver);

            driver.FindElementById(RibbonXPath.New).Click();
            Thread.Sleep(15000);

            driver.FindElementById(SystemReferenceXPath.LookupCodeDDIcon).Click();
            Thread.Sleep(2000);

            driver.FindElementById(lookupCode).Click();
            Thread.Sleep(2000);

            driver.FindElementById(SystemReferenceXPath.OptionName).SendKeys(optionName);
            Thread.Sleep(1000);

            driver.FindElementById(SystemReferenceXPath.Save).Click();
            Thread.Sleep(12000);

            driver.FindElementById(SystemReferenceXPath.ConfirmationOk).Click();
            Thread.Sleep(12000);
        }

        public static void Edit(ChromeDriver driver, string searchOptionName, string updatedOptionName)
        {
            NavigateToPage(driver);
            ToggleFilterFirstRecord(driver, searchOptionName);
            new OpenQA.Selenium.Interactions.Actions(driver).ContextClick(driver.FindElement(By.Id(SystemReferenceXPath.GridData))).Perform();
            Thread.Sleep(3000);
            driver.FindElementById(SystemReferenceXPath.Edit).Click();
            Thread.Sleep(2000);
            driver.FindElementById(SystemReferenceXPath.OptionName).SendKeys(updatedOptionName);
            Thread.Sleep(1000);
            driver.FindElementById(SystemReferenceXPath.Save).Click();
            Thread.Sleep(12000);
            driver.FindElementById(SystemReferenceXPath.ConfirmationOk).Click();
            Thread.Sleep(12000);
        }
    }
}
