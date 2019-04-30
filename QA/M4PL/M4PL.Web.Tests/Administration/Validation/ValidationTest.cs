using M4PL.Web.Tests.Common;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OpenQA.Selenium.Chrome;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace M4PL.Web.Tests.Administration.Validation
{
    [TestClass]
    public class ValidationTest
    {
        ChromeDriver _chromeDriver = new ChromeDriver((Directory.GetParent((Directory.GetParent(Environment.CurrentDirectory)).ToString())).ToString() + @"\Utilities\ExternalFiles");
        LoginTest login = new LoginTest();

        [TestMethod]
        public void Run()
        {
            LoginTest.loginToApplication("diksha", "12345", _chromeDriver);
            Add("Contact", "ConTitleId", "Title is Mandatory", _chromeDriver);

        }
        
    
        public static void Add(string SearchedTableName, string SearchedFieldName, string RequiredMessage, ChromeDriver driver)
        {
            driver.FindElementById(LeftPanelXPath.DBValdtn).Click();
            Thread.Sleep(4000);
            driver.FindElementById(RibbonXPath.New).Click();
            Thread.Sleep(3000);
            driver.FindElementById(ValidationXPath.DBTableName).SendKeys(SearchedTableName);
            Thread.Sleep(2000);
            driver.FindElementById(ValidationXPath.DBFieldName).SendKeys(SearchedFieldName);
            Thread.Sleep(7000);
            //driver.FindElementById(ValidationXPath.SearchedFieldRow).Click();
            //Thread.Sleep(4000);
            driver.FindElementById(ValidationXPath.DBRequired).Click();
            Thread.Sleep(2000);
            driver.FindElementById(ValidationXPath.DBRequiredMessage).SendKeys(RequiredMessage);
            Thread.Sleep(2000);
            driver.FindElementById(ValidationXPath.DBSave).Click();
            Thread.Sleep(5000);
        }
    }
}
