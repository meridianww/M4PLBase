using M4PL.Web.Tests.Common;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System;
using System.IO;
using System.Threading;

namespace M4PL.Web.Tests.Administration.SystemMessage
{
    [TestClass]
    public class SystemMessageTest
    {
        ChromeDriver _chromeDriver = new ChromeDriver((Directory.GetParent((Directory.GetParent(Environment.CurrentDirectory)).ToString())).ToString() + @"\Utilities\ExternalFiles");
        LoginTest login = new LoginTest();

        [TestMethod]
        public void Run()
        {
            login.LoginTestRun("diksha", "12345", _chromeDriver);
            Add(_chromeDriver, "08.02", "test title", "test message title", "Ok", "test description", "test instruction");
            Edit(_chromeDriver, "08.02", "test updated description", "test updated instruction");
        }

        public static void NavigateToPage(ChromeDriver driver)
        {
            Thread.Sleep(4000);
            driver.FindElementById(LeftPanelXPath.SysMsg).Click();
            Thread.Sleep(10000);
        }

        public static void ToggleFilterFirstRecord(ChromeDriver driver, string searchCode)
        {
            driver.FindElementById(RibbonXPath.ToggleFilter).Click();
            Thread.Sleep(2000);
            driver.FindElementById(SystemMessageXPath.ToggleFilterHeaderTextBoxCode).SendKeys(searchCode);
            Thread.Sleep(2000);
        }

        public static void Add(ChromeDriver driver, string code, string title, string msgTitle, string msgButtonSelection, string description, string instruction)
        {
            NavigateToPage(driver);

            driver.FindElementById(RibbonXPath.New).Click();
            Thread.Sleep(15000);

            driver.FindElementById(SystemMessageXPath.Code).SendKeys(code);
            Thread.Sleep(1000);

            driver.FindElementById(SystemMessageXPath.Title).SendKeys(title);
            Thread.Sleep(1000);

            driver.FindElementById(SystemMessageXPath.MsgTitle).SendKeys(msgTitle);
            Thread.Sleep(1000);

            driver.FindElementById(SystemMessageXPath.SystemMsgBtnSelection).SendKeys(msgButtonSelection);
            Thread.Sleep(1000);

            driver.FindElementById(SystemMessageXPath.Description).SendKeys(description);
            Thread.Sleep(1000);

            driver.FindElementById(SystemMessageXPath.Instruction).SendKeys(instruction);
            Thread.Sleep(1000);

            driver.FindElementById(SystemMessageXPath.Save).Click();
            Thread.Sleep(12000);

            driver.FindElementById(SystemMessageXPath.ConfirmationOk).Click();
            Thread.Sleep(12000);
        }

        public static void Edit(ChromeDriver driver, string searchCode, string description, string instruction)
        {
            NavigateToPage(driver);
            ToggleFilterFirstRecord(driver, searchCode);
            new OpenQA.Selenium.Interactions.Actions(driver).ContextClick(driver.FindElement(By.Id(SystemMessageXPath.GridData))).Perform();
            Thread.Sleep(3000);
            driver.FindElementById(SystemMessageXPath.Edit).Click();
            Thread.Sleep(2000);
            driver.FindElementById(SystemMessageXPath.Description).SendKeys(description);
            Thread.Sleep(1000);
            driver.FindElementById(SystemMessageXPath.Instruction).SendKeys(instruction);
            Thread.Sleep(1000);
            driver.FindElementById(SystemMessageXPath.Save).Click();
            Thread.Sleep(12000);
            driver.FindElementById(SystemMessageXPath.ConfirmationOk).Click();
            Thread.Sleep(12000);
        }
    }
}
