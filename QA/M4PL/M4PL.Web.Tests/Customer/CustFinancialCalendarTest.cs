using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Support.UI;
using System;
using System.Threading;

namespace M4PL.Web.Tests.Customer
{
    public class CustFinancialCalendarTest
    {
        public static void Add(String Code, String Title, ChromeDriver driver)
        {
            Thread.Sleep(1000);
            driver.FindElementByXPath(CustomerXPath.CusFinancialCal).Click();
            Thread.Sleep(4000);
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            Thread.Sleep(1000);
            IWebElement FCGrid1 = driver.FindElement(By.Id(CustomerXPath.FCGrid));
            Thread.Sleep(1000);
            action.ContextClick(FCGrid1).Perform();
            Thread.Sleep(3000);
            driver.FindElementById(CustomerXPath.FCNew).Click();
            Thread.Sleep(5000);
            driver.FindElementById(CustomerXPath.FCCode).SendKeys(Code);
            driver.FindElementById(CustomerXPath.FCTitle).SendKeys(Title);
            driver.FindElementById(CustomerXPath.FCPeriodStartIcon).Click();
            Thread.Sleep(1000);
            driver.FindElementById(CustomerXPath.FCPeriodStartTodayIcn).Click();
            Thread.Sleep(1000);
            driver.FindElementById(CustomerXPath.FCPeriodEndIcon).Click();
            Thread.Sleep(1000);
            driver.FindElementById(CustomerXPath.FCPeriodEndTodayIcn).Click();
            Thread.Sleep(1000);
            driver.FindElementById(CustomerXPath.FCSave).Click();
            Thread.Sleep(4000);
            driver.FindElementById(CustomerXPath.FCSaveOkbtn).Click();
            Thread.Sleep(4000);
        }
    }
}
