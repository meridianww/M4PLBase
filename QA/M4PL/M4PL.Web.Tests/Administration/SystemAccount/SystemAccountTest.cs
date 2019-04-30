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

namespace M4PL.Web.Tests.Administration.SystemAccount
{
    [Microsoft.VisualStudio.TestTools.UnitTesting.TestClass]
    public class SystemAccountTest
    {
        ChromeDriver _chromeDriver = new ChromeDriver((Directory.GetParent((Directory.GetParent(Environment.CurrentDirectory)).ToString())).ToString() + @"\Utilities\ExternalFiles");
        LoginTest login = new LoginTest();

        [TestMethod]
        public void Run()
        {
            LoginTest.loginToApplication("diksha", "12345", _chromeDriver);
            Add("JeffW", "Jeff", "W", "JeffW@mailinator.com", "12345678", _chromeDriver);

        }
            
            public static void Add(string screenName, string firstName, string lastName, string indEmail, string password, ChromeDriver driver)
        {
            Thread.Sleep(4000);
            driver.FindElementById(LeftPanelXPath.SysAcc).Click();
            Thread.Sleep(6000);
            driver.FindElementById(RibbonXPath.New).Click();
            Thread.Sleep(7000);
            driver.FindElementById(SystemAccountXPath.SysAccScreenName).SendKeys(screenName);
            Thread.Sleep(4000);
            driver.FindElementById(SystemAccountXPath.SysAccContactCard).Click();
            Thread.Sleep(5000);
            driver.FindElementById(SystemAccountXPath.SysAccConFN).SendKeys(firstName);
            Thread.Sleep(2000);
            driver.FindElementById(SystemAccountXPath.SysAccConLN).SendKeys(lastName);
            Thread.Sleep(2000);
            driver.FindElementById(SystemAccountXPath.SysAccConIndEml).SendKeys(indEmail);
            Thread.Sleep(2000);
            driver.FindElementById(SystemAccountXPath.SysAccConSaveIcn).Click();
            Thread.Sleep(5000);
            driver.FindElementById(SystemAccountXPath.SysAccPassword).SendKeys(password);
            Thread.Sleep(2000);
            driver.FindElementById(SystemAccountXPath.SysAccRoleCodeDrpdwn).Click();
            Thread.Sleep(2000);
            driver.FindElementById(SystemAccountXPath.RoleCodePOC).Click();
            Thread.Sleep(2000);
            driver.FindElementById(SystemAccountXPath.SysAccSave).Click();
            Thread.Sleep(10000);
            driver.FindElementById(SystemAccountXPath.SysAccSaveOk).Click();
            Thread.Sleep(2000);

        }

        public static void Edit(string SearchedContact, ChromeDriver driver)
        {
            Thread.Sleep(2000);
            driver.FindElementById(RibbonXPath.ToggleFilter).Click();
            Thread.Sleep(3000);
            driver.FindElementById(SystemAccountXPath.ToggleFilterContact).SendKeys(SearchedContact);
            Thread.Sleep(4000);
            driver.FindElementById(SystemAccountXPath.ContactSearchedNameRow).Click();
            Thread.Sleep(3000);
            
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            Thread.Sleep(1000);
            IWebElement SysAccGridEdit = driver.FindElement(By.XPath(SystemAccountXPath.SysAccEdit));
            Thread.Sleep(1000);
            action.ContextClick(SysAccGridEdit).Perform();
            Thread.Sleep(3000);
            driver.FindElementById(SystemAccountXPath.SysAccSysAdmn).Click();
            Thread.Sleep(3000);
            driver.FindElementById(SystemAccountXPath.SysAccUpdate).Click();
            Thread.Sleep(10000);
            driver.FindElementById(SystemAccountXPath.SysAccSaveOk).Click();
            Thread.Sleep(2000);
        }

        public static void Invalid(string screenName, string sysContact, string password, string roleCode, ChromeDriver driver )
        {
            Thread.Sleep(4000);
            driver.FindElementById(LeftPanelXPath.SysAcc).Click();
            Thread.Sleep(6000);
            driver.FindElementById(RibbonXPath.New).Click();
            Thread.Sleep(7000);
            driver.FindElementById(SystemAccountXPath.SysAccScreenName).SendKeys(screenName);
            Thread.Sleep(4000);
            driver.FindElementById(SystemAccountXPath.SysAccContact).SendKeys(sysContact);
            Thread.Sleep(2000);
            driver.FindElementById(SystemAccountXPath.SearchedContact).Click();
            Thread.Sleep(4000);
            driver.FindElementById(SystemAccountXPath.SysAccPassword).SendKeys(password);
            Thread.Sleep(2000);
            driver.FindElementById(SystemAccountXPath.SysAccRoleCodeDrpdwn).Click();
            Thread.Sleep(2000);
            driver.FindElementById(SystemAccountXPath.RoleCodePOC).Click();
            Thread.Sleep(2000);
            driver.FindElementById(SystemAccountXPath.SysAccSave).Click();
            Thread.Sleep(10000);
            var errorMsg = driver.FindElementByClassName("errorMessages").Text;
            System.Diagnostics.Debug.WriteLine(!string.IsNullOrWhiteSpace(errorMsg) ? errorMsg : "Success");
            Thread.Sleep(2000);
            driver.FindElementById(SystemAccountXPath.SysAccCancel).Click();
            Thread.Sleep(5000);

        }
    }
}
