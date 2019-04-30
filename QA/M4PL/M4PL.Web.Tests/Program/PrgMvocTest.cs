using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System;
using System.Threading;

namespace M4PL.Web.Tests.Program
{
    public class PrgMvocTest
    {
        public static void Add(string code, string title, ChromeDriver driver)
        {
            driver.FindElementById(ProgramXPath.PrgCustJourney).Click();
            Thread.Sleep(4000);
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            IWebElement mvocGrid = driver.FindElement(By.Id(ProgramXPath.PrgMVOCGrid));
            action.ContextClick(mvocGrid).Perform();
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.PrgMVOCNew).Click();
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgMVOCSurvCode).SendKeys(code);
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgMVOCSurvTitle).SendKeys(title);
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgDateOpenDrpdwn).Click();
            Thread.Sleep(1000);
            driver.FindElementById(ProgramXPath.PrgDateOpenToday).Click();
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.PrgDateCloseDrpdwn).Click();
            Thread.Sleep(1000);
            driver.FindElementById(ProgramXPath.PrgDateCloseToday).Click();
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.PrgMVOCSave).Click();
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.PrgMVOCSaveOk).Click();
            Thread.Sleep(5000);

        }

        public static void Edit(string code, string title, ChromeDriver driver)
        {
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            Thread.Sleep(1000);
            IWebElement mvocGridEdit = driver.FindElement(By.Id(ProgramXPath.PrgMVOCGrid_Record));
            Thread.Sleep(1000);
            action.ContextClick(mvocGridEdit).Perform();
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgMVOCEdit).Click();
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgMVOCSurvCode).SendKeys(code);
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgMVOCSurvTitle).SendKeys(title);
  
            Thread.Sleep(2000);
            driver.FindElementById(ProgramXPath.PrgMVOCSave).Click();
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.PrgMVOCSaveOk).Click();
            Thread.Sleep(4000);
        }

        public static void InvalidTest(string code, string title, ChromeDriver driver)
        {
            driver.FindElementById(ProgramXPath.PrgCustJourney).Click();
            Thread.Sleep(4000);
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            IWebElement mvocGrid = driver.FindElement(By.Id(ProgramXPath.PrgMVOCGrid));
            action.ContextClick(mvocGrid).Perform();
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.PrgMVOCNew).Click();
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgMVOCSurvCode).SendKeys(code);
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgMVOCSurvTitle).SendKeys(title);
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgMVOCSave).Click();
            Thread.Sleep(4000);
            var errorMsg = driver.FindElementByClassName("recordPopupErrorMessages").Text;
            System.Diagnostics.Debug.WriteLine(!string.IsNullOrWhiteSpace(errorMsg) ? errorMsg : "Succeeded");
        }
    }
}
