using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System.Threading;

namespace M4PL.Web.Tests.Program
{
    public class PrgCostCodeTest
    {
        public static void Add(string code, decimal? costPrice, ChromeDriver driver)
        {
            driver.FindElementById(ProgramXPath.PrgCostCode).Click();
            Thread.Sleep(4000);
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            IWebElement PrgCCGrid = driver.FindElement(By.Id(ProgramXPath.PrgCCGrid));
            action.ContextClick(PrgCCGrid).Perform();
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.PrgCCNew).Click();
            Thread.Sleep(6000);
            driver.FindElementById(ProgramXPath.PrgPCCode).SendKeys(code);
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgCCBillablePrice).SendKeys(costPrice.ToString());
            Thread.Sleep(2000);
            driver.FindElementById(ProgramXPath.PrgCCSave).Click();
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.PrgCCSaveOk).Click();
            Thread.Sleep(5000);

        }

        public static void Edit(string code, decimal? costPrice, ChromeDriver driver)
        {
            Thread.Sleep(1000);
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            Thread.Sleep(1000);
            
            IWebElement prgCCGridEdit = driver.FindElement(By.XPath(ProgramXPath.PrgCCGrid));
            Thread.Sleep(1000);
            action.ContextClick(prgCCGridEdit).Perform();
            Thread.Sleep(3000);

            driver.FindElementByXPath(ProgramXPath.PrgCCEdit).Click();
            Thread.Sleep(1000);
            driver.FindElementByXPath(ProgramXPath.PrgCCCode).SendKeys(code);
            Thread.Sleep(1000);
            driver.FindElementByXPath(ProgramXPath.PrgCCBillablePrice).SendKeys(costPrice.ToString());
            Thread.Sleep(1000);
            driver.FindElementById(ProgramXPath.PrgCCSave).Click();
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.PrgCCSaveOk).Click();
            Thread.Sleep(4000);
        }

        public static void InvalidTest(string code, ChromeDriver driver)
        {
            driver.FindElementById(ProgramXPath.PrgCostCode).Click();
            Thread.Sleep(4000);
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            IWebElement PrgCCGrid = driver.FindElement(By.Id(ProgramXPath.PrgCCGrid));
            action.ContextClick(PrgCCGrid).Perform();
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.PrgCCNew).Click();
            Thread.Sleep(6000);
            driver.FindElementById(ProgramXPath.PrgCCCode).SendKeys(code);
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgCCSave).Click();
            Thread.Sleep(5000);
            var errorMsgs = driver.FindElementByClassName("recordPopupErrorMessages").Text;
            System.Diagnostics.Debug.WriteLine(!string.IsNullOrWhiteSpace(errorMsgs) ? errorMsgs : "Succeeded");

        }
    }
}
