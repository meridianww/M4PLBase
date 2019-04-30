using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System;
using System.Threading;

namespace M4PL.Web.Tests.Customer
{
    public class CustDCLocationTest
    {
        public static void Add(String Code, String CustomerCode, String Title, String SearchedContact, ChromeDriver driver)
        {
            driver.FindElementByXPath(CustomerXPath.CusDCLoc).Click();
            Thread.Sleep(6000);
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            Thread.Sleep(5000);
            IWebElement DCGrid1 = driver.FindElement(By.Id(CustomerXPath.DCGrid));
            Thread.Sleep(4000);
            action.ContextClick(DCGrid1).Perform();
            Thread.Sleep(3000);
            driver.FindElementById(CustomerXPath.DCNew).Click();
            Thread.Sleep(5000);
            driver.FindElementById(CustomerXPath.DCCode).SendKeys(Code);
            driver.FindElementById(CustomerXPath.DCTitle).SendKeys(Title);
            driver.FindElementById(CustomerXPath.DCCusCode).SendKeys(CustomerCode);
            driver.FindElementById(CustomerXPath.DCContact).Click();
            driver.FindElement(By.Id(CustomerXPath.DCContact)).SendKeys(SearchedContact);
            Thread.Sleep(2000);
            driver.FindElementByXPath("//td[@id='CdcContactMSTRID_popup_DDD_L_LBI1T0']").Click();
            Thread.Sleep(2000);
            driver.FindElementById(CustomerXPath.DCSaveIcon).Click();
            Thread.Sleep(2000);
            driver.FindElementById(CustomerXPath.DCSaveOkbtn).Click();
            Thread.Sleep(3000);
        }
    }
}
