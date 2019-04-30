using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace M4PL.Web.Tests.Job
{
    public class JobDocReferenceTest
    {
        public static void Add(string code, string title, ChromeDriver driver)
        {
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            IWebElement cargoGrid = driver.FindElement(By.Id(JobXPath.JobDocument));
            action.ContextClick(cargoGrid).Perform();
            Thread.Sleep(4000);

            driver.FindElementById(JobXPath.JobDocByCategoryNew).Click();


            driver.FindElementById(JobXPath.DocCode).SendKeys(code);
            Thread.Sleep(2000);
            driver.FindElementById(JobXPath.DocTitle).SendKeys(title);
            Thread.Sleep(2000);

            driver.FindElementById(JobXPath.JobDocByCategorySave).Click();
            Thread.Sleep(7000);
            driver.FindElementById(JobXPath.JobDocByCategorySaveOk).Click();
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
            driver.FindElementById(JobXPath.DocCode).SendKeys(code);
            Thread.Sleep(2000);
            driver.FindElementById(JobXPath.DocTitle).SendKeys(title);
            Thread.Sleep(2000);

            driver.FindElementById(JobXPath.JobDocByCategorySave).Click();
            Thread.Sleep(7000);
            driver.FindElementById(JobXPath.JobDocByCategorySaveOk).Click();
            Thread.Sleep(8000);

        }

    }
}
