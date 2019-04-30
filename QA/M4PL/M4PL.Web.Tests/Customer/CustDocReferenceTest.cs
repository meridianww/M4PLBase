using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Support.UI;
using System;
using System.Threading;

namespace M4PL.Web.Tests.Customer
{
    public class CustDocReferenceTest
    {
        public static void Add(String Code, String Title, ChromeDriver driver)
        {
            driver.FindElementByXPath(CustomerXPath.CusDoc).Click();
            Thread.Sleep(4000);
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            Thread.Sleep(1000);
            IWebElement CDGrid1 = driver.FindElement(By.Id(CustomerXPath.CDGrid));
            Thread.Sleep(1000);
            action.ContextClick(CDGrid1).Perform();
            Thread.Sleep(1000);
            driver.FindElementById(CustomerXPath.CDNew).Click();
            Thread.Sleep(5000);
            driver.FindElementById(CustomerXPath.CDCode).SendKeys(Code);
            driver.FindElementById(CustomerXPath.CDTitle).SendKeys(Title);
            driver.FindElementById(CustomerXPath.CDDateStartDrpdwnIcn).Click();
            driver.FindElementById(CustomerXPath.CDDateStartTodayBtn).Click();
            driver.FindElementById(CustomerXPath.CDDateEndDrpdwnIcn).Click();
            driver.FindElementById(CustomerXPath.CDDateEndTodayBtn).Click();
            Thread.Sleep(1000);
            driver.FindElementById(CustomerXPath.CDRenewal).Click();
            driver.FindElementById(CustomerXPath.CDSaveIcn).Click();
            Thread.Sleep(2000);
            driver.FindElementById(CustomerXPath.CDSaveOkBtn).Click();
            Thread.Sleep(1000);
        }
    }
}
