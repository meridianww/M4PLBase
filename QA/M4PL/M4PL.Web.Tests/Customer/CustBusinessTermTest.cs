using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Support.UI;
using System;
using System.Threading;

namespace M4PL.Web.Tests.Customer
{
    public class CustBusinessTermTest
    {
        public static void Add(String Code, String Title, ChromeDriver driver)
        {

            Thread.Sleep(1000);
            driver.FindElementByXPath(CustomerXPath.CusBusinessTerms).Click();
            Thread.Sleep(3000);
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            Thread.Sleep(1000);
            IWebElement grid = driver.FindElement(By.Id(CustomerXPath.BTGrid));
            Thread.Sleep(1000);
            action.ContextClick(grid).Perform();
            Thread.Sleep(3000);
            driver.FindElementById(CustomerXPath.BTNew).Click();
            Thread.Sleep(4000);
            driver.FindElementById(CustomerXPath.BTCode).SendKeys(Code);
            driver.FindElementById(CustomerXPath.BTTitle).SendKeys(Title);
            driver.FindElementById(CustomerXPath.BTActiveDate_Icon).Click();
            Thread.Sleep(1000);
            driver.FindElementById(CustomerXPath.BTActiveDate_Today).Click();
            Thread.Sleep(1000);
            driver.FindElementById(CustomerXPath.BTSavebtn).Click();
            Thread.Sleep(5000);
            driver.FindElementById(CustomerXPath.BTSaveOKBtn).Click();
            Thread.Sleep(5000);

        }

        public static void Edit(String Value, String HighThreshold, String LowThreshold, String Status, ChromeDriver driver)
        {
            Thread.Sleep(1000);
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            Thread.Sleep(1000);
            IWebElement BTGridEdit = driver.FindElement(By.XPath(CustomerXPath.BTGridEdit));
            Thread.Sleep(1000);
            action.ContextClick(BTGridEdit).Perform();
            Thread.Sleep(3000);
            driver.FindElementByXPath(CustomerXPath.BTEdit).Click();
            driver.FindElementByXPath(CustomerXPath.BTActiveDate_Icon).Click();

            driver.FindElementByXPath(CustomerXPath.BTActiveDate_Today).Click();
            driver.FindElementByXPath(CustomerXPath.BTValue).SendKeys(Value);
            driver.FindElementByXPath(CustomerXPath.BTHighTh).SendKeys(HighThreshold);
            driver.FindElementByXPath(CustomerXPath.BTLowTh).SendKeys(LowThreshold);
            driver.FindElementByXPath(CustomerXPath.BTStatus).Click();
            SelectElement BStatus = new SelectElement(driver.FindElement(By.XPath(CustomerXPath.BTStatus)));
            BStatus.SelectByText("Inactive");
            driver.FindElementById(CustomerXPath.BTSaveOKBtn).Click();
            Thread.Sleep(5000);
        }
    }
}
