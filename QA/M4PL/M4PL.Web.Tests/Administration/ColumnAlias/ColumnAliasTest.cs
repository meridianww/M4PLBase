using M4PL.Web.Tests.Common;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System;
using System.IO;
using System.Threading;

namespace M4PL.Web.Tests.Administration.ColumnAlias
{
    [TestClass]
    public class ColumnAliasTest
    {
        ChromeDriver _chromeDriver = new ChromeDriver((Directory.GetParent((Directory.GetParent(Environment.CurrentDirectory)).ToString())).ToString() + @"\Utilities\ExternalFiles");
        LoginTest login = new LoginTest();

        [TestMethod]
        public void Run()
        {
            LoginTest.loginToApplication("diksha", "12345", _chromeDriver);
            Edit(_chromeDriver, "ColIsReadOnly", isReadOnly: true);
        }


        public static void NavigateToPage(ChromeDriver driver)
        {
            Thread.Sleep(5000);
            driver.FindElementById(RibbonXPath.AdministrationTab).Click();
            Thread.Sleep(1000);
            driver.FindElementById(RibbonXPath.AliasColumn).Click();
            Thread.Sleep(10000);
            NavigateToFileTabInRibbon(driver);
        }

        public static void NavigateToFileTabInRibbon(ChromeDriver driver)
        {
            driver.FindElementById(RibbonXPath.File).Click();
            Thread.Sleep(1000);
        }

        public static void Add(ChromeDriver driver, string sortOrder, string aliasName, string caption, bool isReadOnly, bool isVisible, bool isDefault)
        {
            NavigateToPage(driver);
            driver.FindElementById(RibbonXPath.New).Click();
            Thread.Sleep(15000);
            driver.FindElementById(ColumnAliasXPath.SortOrder).SendKeys(sortOrder);
            Thread.Sleep(1000);
            driver.FindElementById(ColumnAliasXPath.AliasName).SendKeys(aliasName);
            Thread.Sleep(1000);
            driver.FindElementById(ColumnAliasXPath.Caption).SendKeys(caption);
            Thread.Sleep(1000);
            if (isReadOnly)
            {
                driver.FindElementById(ColumnAliasXPath.IsReadOnly).Click();
                Thread.Sleep(1000);
            }
            if (isVisible)
            {
                driver.FindElementById(ColumnAliasXPath.IsVisible).Click();
                Thread.Sleep(1000);
            }
            if (isDefault)
            {
                driver.FindElementById(ColumnAliasXPath.IsDefault).Click();
                Thread.Sleep(1000);
            }

        }

        public static void Edit(ChromeDriver driver, string searchColName, string sortOrder = null, string aliasName = null, string caption = null, bool isReadOnly = false, bool isVisible = false, bool isDefault = false)
        {
            NavigateToPage(driver);

            driver.FindElementById(RibbonXPath.ToggleFilter).Click();
            Thread.Sleep(2000);

            driver.FindElementById(ColumnAliasXPath.DDTableNameIcon).Click();
            Thread.Sleep(2000);

            driver.FindElementById(ColumnAliasXPath.DDTableNameOptionColumnAlias).Click();
            Thread.Sleep(5000);

            driver.FindElementById(ColumnAliasXPath.ColumnNameHeaderTextBox).SendKeys(searchColName);
            Thread.Sleep(2000);

            new OpenQA.Selenium.Interactions.Actions(driver).ContextClick(driver.FindElement(By.Id(ColumnAliasXPath.FirstRow))).Perform();
            Thread.Sleep(3000);

            driver.FindElementById(ColumnAliasXPath.EditContextMenu).Click();
            Thread.Sleep(2000);

            if (isReadOnly)
            {
                driver.FindElementById(ColumnAliasXPath.IsReadOnly).Click();
                Thread.Sleep(1000);
            }
            if (isVisible)
            {
                driver.FindElementById(ColumnAliasXPath.IsVisible).Click();
                Thread.Sleep(1000);
            }
            if (isDefault)
            {
                driver.FindElementById(ColumnAliasXPath.IsDefault).Click();
                Thread.Sleep(1000);
            }

            driver.FindElementById(ColumnAliasXPath.Savebtn).Click();
            Thread.Sleep(7000);

            driver.FindElementById(ColumnAliasXPath.ConfirmationOk).Click();
            Thread.Sleep(7000);
        }

    }
}
