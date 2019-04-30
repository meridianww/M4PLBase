using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System.Threading;

namespace M4PL.Web.Tests.Job
{
    public class JobGatewayTest
    {
        public static void Add(string code, string title, ChromeDriver driver)
        {
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            IWebElement gatewayAllGrid = driver.FindElement(By.Id(JobXPath.JobGatewaysAll));
            action.ContextClick(gatewayAllGrid).Perform();
            Thread.Sleep(4000);

            driver.FindElementById(JobXPath.JobGatewaysAllGridNew).Click();


            driver.FindElementById(JobXPath.Code).SendKeys(code);
            Thread.Sleep(2000);
            driver.FindElementById(JobXPath.Title).SendKeys(title);
            Thread.Sleep(2000);

            driver.FindElementById(JobXPath.JobGatewaysAllSave).Click();
            Thread.Sleep(7000);
            driver.FindElementById(JobXPath.JobGatewaysAllSaveOk).Click();
            Thread.Sleep(8000);
        }

        public static void Edit(string customerSaleOrder, string siteCode, ChromeDriver driver)
        {
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            Thread.Sleep(1000);
            IWebElement jobGatewayAllEdit = driver.FindElement(By.Id(JobXPath.JobGatewaysAll_Record));
            Thread.Sleep(1000);
            action.ContextClick(jobGatewayAllEdit).Perform();
            Thread.Sleep(3000);
            driver.FindElementById(JobXPath.JobGatewaysAllEdit).Click();
            Thread.Sleep(7000);
            driver.FindElementById(JobXPath.Code).SendKeys(customerSaleOrder);
            Thread.Sleep(2000);
            driver.FindElementById(JobXPath.Title).SendKeys(siteCode);
            Thread.Sleep(2000);

            driver.FindElementById(JobXPath.JobGatewaysAllSave).Click();
            Thread.Sleep(7000);
            driver.FindElementById(JobXPath.JobGatewaysAllSaveOk).Click();
            Thread.Sleep(8000);

        }
    }
}
