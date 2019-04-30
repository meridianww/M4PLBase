using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System;
using System.Threading;

namespace M4PL.Web.Tests.Program
{
    public class PrgShipStatusReasonCodeTest
    {
        public static void Add(string code, string title, ChromeDriver driver)
        {
            driver.FindElementById(ProgramXPath.PrgRsnCode).Click();
            Thread.Sleep(4000);
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            IWebElement reasonGrid = driver.FindElement(By.Id(ProgramXPath.PrgRCGrid));
            action.ContextClick(reasonGrid).Perform();
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.PrgRCNew).Click();
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgRCReasonCode).SendKeys(code);
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgRCTitle).SendKeys(title);
            Thread.Sleep(3000);

            driver.FindElementById(ProgramXPath.PrgRCSave).Click();
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.PrgRCSaveOk).Click();
            Thread.Sleep(5000);

        }

        public static void Edit(string code, string title, ChromeDriver driver)
        {
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            Thread.Sleep(1000);
            IWebElement reasonGrid = driver.FindElement(By.Id(ProgramXPath.PrgRCGrid_Record));
            Thread.Sleep(1000);
            action.ContextClick(reasonGrid).Perform();
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgRCEdit).Click();
            Thread.Sleep(7000);
            driver.FindElementById(ProgramXPath.PrgRCReasonCode).SendKeys(code);
            Thread.Sleep(2000);
            driver.FindElementById(ProgramXPath.PrgRCTitle).SendKeys(title);
            Thread.Sleep(2000);
            driver.FindElementById(ProgramXPath.PrgRCSave).Click();
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.PrgRCSaveOk).Click();
            Thread.Sleep(4000);
        }

        public static void InvalidTest(string code, ChromeDriver driver)
        {
            driver.FindElementById(ProgramXPath.PrgRsnCode).Click();
            Thread.Sleep(4000);
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            IWebElement reasonGrid = driver.FindElement(By.Id(ProgramXPath.PrgRCGrid));
            action.ContextClick(reasonGrid).Perform();
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.PrgRCNew).Click();
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgRCReasonCode).SendKeys(code);
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgRCSave).Click();
            Thread.Sleep(4000);
            var errorMsg = driver.FindElementByClassName("recordPopupErrorMessages").Text;
            System.Diagnostics.Debug.WriteLine(!string.IsNullOrWhiteSpace(errorMsg) ? errorMsg : "Succeeded");
            Thread.Sleep(2000);
            driver.FindElementById(ProgramXPath.PrgACCancel).Click();
            Thread.Sleep(2000);
        }
    }
}
