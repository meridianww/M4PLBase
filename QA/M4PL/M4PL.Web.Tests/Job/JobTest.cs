using M4PL.Web.Tests.Common;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System;
using System.IO;
using System.Threading;

namespace M4PL.Web.Tests.Job
{
    [TestClass]
    public class JobTest
    {
        ChromeDriver _chromeDriver = new ChromeDriver((Directory.GetParent((Directory.GetParent(Environment.CurrentDirectory)).ToString())).ToString() + @"\Utilities\ExternalFiles");
        LoginTest login = new LoginTest();
        [TestMethod]
        public void Run()
        {
            LoginTest.loginToApplication("diksha", "12345", _chromeDriver);
            Add("JBSLORD", "stecode", _chromeDriver);
            //JobGatewayTest.Add("PRG_GTW", "384", _chromeDriver);
            //JobAttributeTest.Add("PGR_CDE", "PGR_TITLE", "293", _chromeDriver);
        }

        public static void Add(string customerSaleOrder, string siteCode, ChromeDriver driver)
        {
            Thread.Sleep(3000);
            driver.FindElementById(LeftPanelXPath.JbsDVS).Click();
            Thread.Sleep(8000);
            driver.FindElementByXPath(JobXPath.CusCodeSearch).Click();
            Thread.Sleep(3000);
            driver.FindElementById(JobXPath.CusCodeDrillDown).Click();
            Thread.Sleep(3000);
            driver.FindElementByXPath(JobXPath.PrgCodeSearch).Click();
            Thread.Sleep(3000);
            driver.FindElementById(RibbonXPath.New).Click();
            Thread.Sleep(6000);
            driver.FindElementById(JobXPath.CustomerSalesOrder).SendKeys(customerSaleOrder);
            Thread.Sleep(2000);
            driver.FindElementById(JobXPath.SiteCode).SendKeys(siteCode);
            Thread.Sleep(2000);

            driver.FindElementById(JobXPath.JobSave).Click();
            Thread.Sleep(7000);
            driver.FindElementById(JobXPath.JobSaveOk).Click();
            Thread.Sleep(8000);
        }

        public static void Edit(string customerSaleOrder, string siteCode, ChromeDriver driver)
        {
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            Thread.Sleep(1000);
            IWebElement jobGridEdit = driver.FindElement(By.Id(JobXPath.JobGrid_Record));
            Thread.Sleep(1000);
            action.ContextClick(jobGridEdit).Perform();
            Thread.Sleep(3000);
            driver.FindElementById(JobXPath.JobEdit).Click();
            Thread.Sleep(7000);
            driver.FindElementById(JobXPath.CustomerSalesOrder).SendKeys(customerSaleOrder);
            Thread.Sleep(2000);
            driver.FindElementById(JobXPath.SiteCode).SendKeys(siteCode);
            Thread.Sleep(2000);

            driver.FindElementById(JobXPath.JobUpdatebtn).Click();
            Thread.Sleep(7000);
            driver.FindElementById(JobXPath.JobSaveOk).Click();
            Thread.Sleep(8000);

        }
    }
}
