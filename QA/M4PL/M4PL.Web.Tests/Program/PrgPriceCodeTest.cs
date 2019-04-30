using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System.Threading;

namespace M4PL.Web.Tests.Program
{
    public class PrgPriceCodeTest
    {
        public static void Add(string code, decimal? priceRate, ChromeDriver driver)
        {
            driver.FindElementById(ProgramXPath.PrgPriceCode).Click();
            Thread.Sleep(4000);
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            IWebElement prgPCGrid = driver.FindElement(By.Id(ProgramXPath.PrgPCGrid));
            action.ContextClick(prgPCGrid).Perform();
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.PrgPCNew).Click();
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgPCCode).SendKeys(code);
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgPCBillablePrice).SendKeys(priceRate.ToString());
            Thread.Sleep(2000);
            driver.FindElementById(ProgramXPath.PrgPCSave).Click();
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.PrgPCSaveOk).Click();
            Thread.Sleep(5000);

        }

        public static void Edit(string code, decimal? priceRate, ChromeDriver driver)
        {
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            Thread.Sleep(1000);
            IWebElement prgPCGridEdit = driver.FindElement(By.Id(ProgramXPath.PrgPCEdit));
            Thread.Sleep(1000);
            action.ContextClick(prgPCGridEdit).Perform();
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgPCEdit).Click();
            Thread.Sleep(7000);
            driver.FindElementById(ProgramXPath.PrgPCCode).SendKeys(priceRate.ToString());
            Thread.Sleep(2000);
     
            driver.FindElementById(ProgramXPath.PrgPCSave).Click();
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.PrgPCSaveOk).Click();
            Thread.Sleep(4000);
        }

        public static void InvalidTest(string code, decimal? priceRate, ChromeDriver driver)
        {
            driver.FindElementById(ProgramXPath.PrgPriceCode).Click();
            Thread.Sleep(4000);
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            IWebElement prgPCGrid = driver.FindElement(By.Id(ProgramXPath.PrgPCGrid));
            action.ContextClick(prgPCGrid).Perform();
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.PrgPCNew).Click();
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgPCCode).SendKeys(code);
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgPCBillablePrice).SendKeys(priceRate.ToString());
            Thread.Sleep(2000);
            driver.FindElementById(ProgramXPath.PrgPCSave).Click();
            Thread.Sleep(4000);
            var errorMsgs = driver.FindElementByClassName("recordPopupErrorMessages").Text;


            System.Diagnostics.Debug.WriteLine(!string.IsNullOrWhiteSpace(errorMsgs) ? errorMsgs : "Succeeded");
        }
    }
}
