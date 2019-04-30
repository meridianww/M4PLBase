using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System;
using System.Threading;

namespace M4PL.Web.Tests.Customer
{
    public class CustContactTest
    {
        public static void Add(String Code, String Title, String SearchedCContact, ChromeDriver driver)
        {
            driver.FindElementByXPath(CustomerXPath.CusCustContact).Click();
            Thread.Sleep(4000);
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            Thread.Sleep(5000);
            IWebElement CCGrid1 = driver.FindElement(By.Id(CustomerXPath.CCGrid));
            Thread.Sleep(4000);
            action.ContextClick(CCGrid1).Perform();
            Thread.Sleep(3000);
            driver.FindElementById(CustomerXPath.CCNew).Click();
            Thread.Sleep(5000);
            driver.FindElementById(CustomerXPath.CCCode).SendKeys(Code);
            driver.FindElementById(CustomerXPath.CCTitle).SendKeys(Title);
            driver.FindElementById(CustomerXPath.CCContact).Click();
            driver.FindElement(By.Id(CustomerXPath.CCContact)).SendKeys(SearchedCContact);
            Thread.Sleep(5000);
            driver.FindElementByXPath("//td[@id='CustContactMSTRID_popup_DDD_L_LBI0T0']").Click();
            Thread.Sleep(2000);
            driver.FindElementById(CustomerXPath.CCSaveIcn).Click();
            Thread.Sleep(3000);
            driver.FindElementById(CustomerXPath.CCSaveOkBtn).Click();
            Thread.Sleep(5000);

        }
    }
}
