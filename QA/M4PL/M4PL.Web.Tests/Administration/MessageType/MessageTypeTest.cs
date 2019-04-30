using M4PL.Web.Tests.Common;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace M4PL.Web.Tests.Administration.MessageType
{
    [TestClass]
    public class MessageTypeTest
    {
        ChromeDriver _chromeDriver = new ChromeDriver((Directory.GetParent((Directory.GetParent(Environment.CurrentDirectory)).ToString())).ToString() + @"\Utilities\ExternalFiles");
        LoginTest login = new LoginTest();

        [TestMethod]
        public void Run()
        {
            login.LoginTestRun("diksha", "12345", _chromeDriver);
            Add(_chromeDriver, "testTitle", @"C:\Users\dharmendra.verma\Desktop\download.PNG");
            Edit(_chromeDriver, "testTitle", "testUpdatedTitle");
        }

        public static void NavigateToPage(ChromeDriver driver)
        {
            Thread.Sleep(4000);
            driver.FindElementById(LeftPanelXPath.MsgTyp).Click();
            Thread.Sleep(10000);
        }

        public static void ToggleFilterFirstRecord(ChromeDriver driver, string searchTitle)
        {
            driver.FindElementById(RibbonXPath.ToggleFilter).Click();
            Thread.Sleep(2000);
            driver.FindElementById(MessageTypeXPath.ToggleFilterHeaderTextBoxTitle).SendKeys(searchTitle);
            Thread.Sleep(2000);
        }

        public static void Add(ChromeDriver driver, string title, string iconPath)
        {
            NavigateToPage(driver);

            driver.FindElementById(RibbonXPath.New).Click();
            Thread.Sleep(15000);

            driver.FindElementById(MessageTypeXPath.Title).SendKeys(title);
            Thread.Sleep(1000);

            ImageUpload.FileUpload(driver, MessageTypeXPath.HeaderIcon, iconPath);
            Thread.Sleep(5000);

            ImageUpload.FileUpload(driver, MessageTypeXPath.Icon, iconPath);
            Thread.Sleep(5000);

            driver.FindElementById(MessageTypeXPath.Save).Click();
            Thread.Sleep(12000);

            driver.FindElementById(MessageTypeXPath.ConfirmationOk).Click();
            Thread.Sleep(12000);
        }

        public static void Edit(ChromeDriver driver, string searchTitle, string updatedTitle)
        {
            NavigateToPage(driver);
            ToggleFilterFirstRecord(driver, searchTitle);
            new OpenQA.Selenium.Interactions.Actions(driver).ContextClick(driver.FindElement(By.Id(MessageTypeXPath.GridData))).Perform();
            Thread.Sleep(3000);
            driver.FindElementById(MessageTypeXPath.Edit).Click();
            Thread.Sleep(2000);
            driver.FindElementById(MessageTypeXPath.Title).SendKeys(updatedTitle);
            Thread.Sleep(1000);
            driver.FindElementById(MessageTypeXPath.Save).Click();
            Thread.Sleep(12000);
            driver.FindElementById(MessageTypeXPath.ConfirmationOk).Click();
            Thread.Sleep(12000);
        }
    }
}
