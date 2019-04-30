using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System.Threading;

namespace M4PL.Web.Tests.Program
{
    public class PrgVendLocationTest
    {
        public static void Add(string Code, string Duration, ChromeDriver driver)
        {
           

        }

        public static void Edit(string code, ChromeDriver driver)
        {
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            Thread.Sleep(1000);
            IWebElement vendorGridEdit = driver.FindElement(By.Id(ProgramXPath.PrgVendorGrid_Record));
            Thread.Sleep(1000);
            action.ContextClick(vendorGridEdit).Perform();
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgVendorEdit).Click();
            Thread.Sleep(7000);
            driver.FindElementById(ProgramXPath.PrgVendorLocCode).SendKeys(code);
            Thread.Sleep(2000);
           
            driver.FindElementById(ProgramXPath.PrgVendSave).Click();
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.PrgVendSaveOk).Click();
            Thread.Sleep(4000);
        }
    }
}
