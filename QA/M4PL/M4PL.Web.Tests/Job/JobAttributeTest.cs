using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System.Threading;

namespace M4PL.Web.Tests.Job
{
    public class JobAttributeTest
    {
        public static void Add(string code, string title, ChromeDriver driver)
        {
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            IWebElement attributeGrid = driver.FindElement(By.Id(JobXPath.JobAttributes));
            action.ContextClick(attributeGrid).Perform();
            Thread.Sleep(4000);

            driver.FindElementById(JobXPath.JobAttrbuteNew).Click();


            driver.FindElementById(JobXPath.AttCode).SendKeys(code);
            Thread.Sleep(2000);
            driver.FindElementById(JobXPath.AttTitle).SendKeys(title);
            Thread.Sleep(2000);

            driver.FindElementById(JobXPath.JobAttrbuteSave).Click();
            Thread.Sleep(7000);
            driver.FindElementById(JobXPath.JobAttrbuteSaveOk).Click();
            Thread.Sleep(8000);
        }

        public static void Edit(string code, string title, ChromeDriver driver)
        {
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            Thread.Sleep(1000);
            IWebElement jobDocEdit = driver.FindElement(By.Id(JobXPath.JobDocByCategory_Record));
            Thread.Sleep(1000);
            action.ContextClick(jobDocEdit).Perform();
            Thread.Sleep(3000);
            driver.FindElementById(JobXPath.JobDocByCategoryEdit).Click();
            Thread.Sleep(7000);
            driver.FindElementById(JobXPath.AttCode).SendKeys(code);
            Thread.Sleep(2000);
            driver.FindElementById(JobXPath.AttTitle).SendKeys(title);
            Thread.Sleep(2000);

            driver.FindElementById(JobXPath.JobAttrbuteSave).Click();
            Thread.Sleep(7000);
            driver.FindElementById(JobXPath.JobAttrbuteSaveOk).Click();
            Thread.Sleep(8000);

        }

    }
}
