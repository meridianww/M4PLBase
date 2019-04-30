using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System;
using System.Threading;

namespace M4PL.Web.Tests.Program
{
    public class PrgShipApptmtReasonCodeTest
    {
        public static void Add(string code, string title, ChromeDriver driver)
        {
            driver.FindElementById(ProgramXPath.PrgApptCode).Click();
            Thread.Sleep(4000);
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            IWebElement appointmentGrid = driver.FindElement(By.Id(ProgramXPath.PrgACGrid));
            action.ContextClick(appointmentGrid).Perform();
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.PrgACNew).Click();
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgACReasonCode).SendKeys(code);
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgACTitle).SendKeys(code);
            Thread.Sleep(3000);

            driver.FindElementById(ProgramXPath.PrgACSave).Click();
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.PrgACSaveOk).Click();
            Thread.Sleep(5000);

        }

        public static void Edit(string code, string title, ChromeDriver driver)
        {
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            Thread.Sleep(1000);
            IWebElement appointmentGrid = driver.FindElement(By.Id(ProgramXPath.PrgACGrid_Record));
            Thread.Sleep(1000);
            action.ContextClick(appointmentGrid).Perform();
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgACEdit).Click();
            Thread.Sleep(7000);
            driver.FindElementById(ProgramXPath.PrgACReasonCode).SendKeys(code);
            Thread.Sleep(2000);
            driver.FindElementById(ProgramXPath.PrgACTitle).SendKeys(title);
            Thread.Sleep(2000);
            driver.FindElementById(ProgramXPath.PrgACSave).Click();
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.PrgACSaveOk).Click();
            Thread.Sleep(4000);
        }

        public static void InvalidTest(string code, ChromeDriver driver)
        {
            driver.FindElementById(ProgramXPath.PrgApptCode).Click();
            Thread.Sleep(4000);
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            IWebElement appointmentGrid = driver.FindElement(By.Id(ProgramXPath.PrgACGrid));
            action.ContextClick(appointmentGrid).Perform();
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.PrgACNew).Click();
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgACReasonCode).SendKeys(code);
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgACSave).Click();
            Thread.Sleep(2000);
            var errorMsg = driver.FindElementByClassName("").Text;
            System.Diagnostics.Debug.WriteLine(!string.IsNullOrWhiteSpace(errorMsg) ? errorMsg : "Succeeded");
            Thread.Sleep(2000);
            driver.FindElementById(ProgramXPath.PrgACCancel).Click();
            Thread.Sleep(2000);
        }
    }
}
