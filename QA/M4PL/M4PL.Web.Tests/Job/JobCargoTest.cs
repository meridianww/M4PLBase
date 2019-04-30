using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System.Threading;

namespace M4PL.Web.Tests.Job
{
    public class JobCargoTest
    {
        public static void Add(string partNumberCode, string title, ChromeDriver driver)
        {
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            IWebElement cargoGrid = driver.FindElement(By.Id(JobXPath.JobCargo));
            action.ContextClick(cargoGrid).Perform();
            Thread.Sleep(4000);

            driver.FindElementById(JobXPath.JobCargoNew).Click();


            driver.FindElementById(JobXPath.NumberCode).SendKeys(partNumberCode);
            Thread.Sleep(2000);
            driver.FindElementById(JobXPath.CargoTitle).SendKeys(title);
            Thread.Sleep(2000);

            driver.FindElementById(JobXPath.JobCargoSave).Click();
            Thread.Sleep(7000);
            driver.FindElementById(JobXPath.JobCargoSaveOk).Click();
            Thread.Sleep(8000);
        }

        public static void Edit(string partNumberCode, string title, ChromeDriver driver)
        {
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            Thread.Sleep(1000);
            IWebElement jobCargoEdit = driver.FindElement(By.Id(JobXPath.JobCargoGrid_Record));
            Thread.Sleep(1000);
            action.ContextClick(jobCargoEdit).Perform();
            Thread.Sleep(3000);
            driver.FindElementById(JobXPath.JobCargoEdit).Click();
            Thread.Sleep(7000);
            driver.FindElementById(JobXPath.NumberCode).SendKeys(partNumberCode);
            Thread.Sleep(2000);
            driver.FindElementById(JobXPath.CargoTitle).SendKeys(title);
            Thread.Sleep(2000);

            driver.FindElementById(JobXPath.JobCargoSave).Click();
            Thread.Sleep(7000);
            driver.FindElementById(JobXPath.JobCargoSaveOk).Click();
            Thread.Sleep(8000);

        }
    }
}
