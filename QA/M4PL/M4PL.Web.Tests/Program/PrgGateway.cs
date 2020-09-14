using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Interactions;
using System;
using System.Threading;

namespace M4PL.Web.Tests.Program
{
    public class PrgGateway
    {
        public static void AddGateway(string code , string title, ChromeDriver driver)
        {
            driver.FindElementById(ProgramXPath.PrgGateways).Click();
            Actions action = new Actions(driver);
            Thread.Sleep(8000);
            IWebElement GtwGrid1 = driver.FindElement(By.Id(ProgramXPath.PrgGtwGrid_Record));
            Thread.Sleep(4000);
            action.ContextClick(GtwGrid1).Perform();           
            driver.FindElementById(ProgramXPath.PrgGtwNew).Click();
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.PrgGtwCode).SendKeys(code);
            driver.FindElementById(ProgramXPath.PrgGtwTitle).SendKeys(title);
            driver.FindElementById(ProgramXPath.PrgGtwDefault).Click();
            driver.FindElementById(ProgramXPath.PrgGtwSave).Click();
            Thread.Sleep(8000);
            driver.FindElementById(ProgramXPath.PrgGtwSaveOk).Click();
        }
        public static void Add(string code, decimal? gatewayDuration, ChromeDriver driver)
        {
            driver.FindElementById(ProgramXPath.PrgGateways).Click();
            Thread.Sleep(4000);
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            IWebElement GtwGrid1 = driver.FindElement(By.Id(ProgramXPath.PrgGtwGrid));
            action.ContextClick(GtwGrid1).Perform();
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.PrgGtwNew).Click();
            Thread.Sleep(6000);
            driver.FindElementById(ProgramXPath.PrgGtwCode).SendKeys(code);
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgGtwDuration).SendKeys(gatewayDuration.ToString());
            Thread.Sleep(2000);
            driver.FindElementById(ProgramXPath.PrgGtwDefault).Click();
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgGtwSave).Click();
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.PrgGtwSaveOk).Click();
            Thread.Sleep(5000);

        }

        public static void Edit(string title, ChromeDriver driver)
        {
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            Thread.Sleep(1000);
            IWebElement GtwGridEdit = driver.FindElement(By.Id(ProgramXPath.PrgGtwGrid_Record));
            Thread.Sleep(1000);
            action.ContextClick(GtwGridEdit).Perform();
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgGtwEdit).Click();
            Thread.Sleep(7000);
            driver.FindElementById(ProgramXPath.PrgTitle).SendKeys(title);
            Thread.Sleep(2000);
            driver.FindElementById(ProgramXPath.PrgGtwScanner).Click();
            Thread.Sleep(2000);
            driver.FindElementById(ProgramXPath.PrgGtwSave).Click();
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.PrgGtwSaveOk).Click();
            Thread.Sleep(4000);
        }

        public static void InvalidTest(string code, decimal? gatewayDuration, ChromeDriver driver)
        {
            driver.FindElementById(ProgramXPath.PrgGateways).Click();
            Thread.Sleep(4000);
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            IWebElement GtwGrid = driver.FindElement(By.Id(ProgramXPath.PrgGtwGrid));
            action.ContextClick(GtwGrid).Perform();
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.PrgGtwNew).Click();
            Thread.Sleep(6000);
            driver.FindElementById(ProgramXPath.PrgGtwCode).SendKeys(code);
            Thread.Sleep(3000);
            
            var errorMsg = driver.FindElementByClassName("recordPopupErrorMessages").Text;
            System.Diagnostics.Debug.WriteLine(!string.IsNullOrWhiteSpace(errorMsg) ? errorMsg : "Succeeded");
        }
    }
}
