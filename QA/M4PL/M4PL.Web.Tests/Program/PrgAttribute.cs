using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Support.UI;
using System.Threading;

namespace M4PL.Web.Tests.Program
{
    public class PrgAttribute
    {
        public static void Add(string code, string title, string quantity, ChromeDriver driver)
        {
            Thread.Sleep(2000);
            driver.FindElementById(ProgramXPath.PrgAttribute).Click();
            Thread.Sleep(5000);
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            IWebElement AttGrid = driver.FindElement(By.Id(ProgramXPath.PrgAttGrid));
            action.ContextClick(AttGrid).Perform();
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.PrgAttNew).Click();
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgAttCode).SendKeys(code);
            Thread.Sleep(2000);
            driver.FindElementById(ProgramXPath.PrgAttTitle).SendKeys(title);
            Thread.Sleep(2000);
            driver.FindElementById(ProgramXPath.PrgAttQty).SendKeys(quantity);
            Thread.Sleep(2000);
            driver.FindElementById(ProgramXPath.PrgAttDefault).Click();
            Thread.Sleep(2000);
            driver.FindElementById(ProgramXPath.PrgAttSave).Click();
            Thread.Sleep(5000);
            driver.FindElementById(ProgramXPath.PrgAttSaveOk).Click();
            Thread.Sleep(5000);
        }

        public static void Edit(string code, string title, string quantity, ChromeDriver driver)
        {
            Thread.Sleep(1000);
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            Thread.Sleep(1000);

            //For right click on Grid and PrgAttEdit is for RowId on grid
            IWebElement attributeGridEdit = driver.FindElement(By.XPath(ProgramXPath.PrgAttEdit));
            Thread.Sleep(1000);
            action.ContextClick(attributeGridEdit).Perform();
            Thread.Sleep(3000);
           
            driver.FindElementByXPath(ProgramXPath.PrgAttEdit).Click();
            Thread.Sleep(3000);
            driver.FindElementByXPath(ProgramXPath.PrgAttCode).SendKeys(code);
            Thread.Sleep(3000);
            driver.FindElementByXPath(ProgramXPath.PrgAttTitle).SendKeys(title);
            Thread.Sleep(3000);
            driver.FindElementByXPath(ProgramXPath.PrgAttQty).SendKeys(quantity);
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgAttSaveOk).Click();
            Thread.Sleep(5000);
        }

        public static void InvalidTest(string attributeCode, ChromeDriver driver)
        {
            Thread.Sleep(2000);
            driver.FindElementById(ProgramXPath.PrgAttribute).Click();
            Thread.Sleep(6000);
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            IWebElement AttGrid = driver.FindElement(By.Id(ProgramXPath.PrgAttGrid));
            action.ContextClick(AttGrid).Perform();
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.PrgGtwNew).Click();
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgAttCode).SendKeys(attributeCode);
            Thread.Sleep(2000);
            driver.FindElementById(ProgramXPath.PrgAttSave).Click();
            Thread.Sleep(5000);
            var errorMsgs = driver.FindElementByClassName("recordPopupErrorMessages").Text;
            System.Diagnostics.Debug.WriteLine(!string.IsNullOrWhiteSpace(errorMsgs) ? errorMsgs : "Succeeded");

        }

    }
}
