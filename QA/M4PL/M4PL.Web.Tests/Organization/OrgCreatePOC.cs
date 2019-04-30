using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace M4PL.Web.Tests.Organization
{
    public class OrgCreatePOC
    {
        public static void AddPOC(string code, string title, string firstName, string lastName, string indEml, ChromeDriver driver)
        {
            driver.FindElementById(ScreensControls.OrgPOCTab).Click();
            Thread.Sleep(3000);
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            Thread.Sleep(1000);
            IWebElement POCGrid1 = driver.FindElement(By.Id(ScreensControls.OrgPOCGrid));
            Thread.Sleep(1000);
            action.ContextClick(POCGrid1).Perform();
            Thread.Sleep(3000);
            driver.FindElementById(ScreensControls.OrgPOCNew).Click();
            Thread.Sleep(6000);
            driver.FindElementById(ScreensControls.OrgPOCCode).SendKeys(code);
            Thread.Sleep(1000);
            driver.FindElementById(ScreensControls.OrgPOCTitle).SendKeys(title);
            Thread.Sleep(1000);
            driver.FindElementById(ScreensControls.OrgPOCContactCard).Click();
            Thread.Sleep(7000);
            driver.FindElementById(ScreensControls.POCConFN).SendKeys(firstName);
            Thread.Sleep(2000);
            driver.FindElementById(ScreensControls.POCConLN).SendKeys(lastName);
            Thread.Sleep(1000);
            driver.FindElementById(ScreensControls.POCConIndEml).SendKeys(indEml);
            Thread.Sleep(2000);
            driver.FindElementById(ScreensControls.POCConSaveIcn).Click();
            Thread.Sleep(8000);
            driver.FindElementById(ScreensControls.OrgPOCDefault).Click();
            Thread.Sleep(1000);
            driver.FindElementById(ScreensControls.OrgPOCSave).Click();
            Thread.Sleep(8000);
            driver.FindElementById(ScreensControls.OrgPOCSaveOk).Click();
            Thread.Sleep(8000);
        }

        public static void Invalid(string code, string title, ChromeDriver driver)
        {
            driver.FindElementById(ScreensControls.OrgPOCTab).Click();
            Thread.Sleep(3000);
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            Thread.Sleep(1000);
            IWebElement POCGrid1 = driver.FindElement(By.Id(ScreensControls.OrgPOCGrid));
            Thread.Sleep(1000);
            action.ContextClick(POCGrid1).Perform();
            Thread.Sleep(3000);
            driver.FindElementById(ScreensControls.OrgPOCNew).Click();
            Thread.Sleep(6000);
            driver.FindElementById(ScreensControls.OrgPOCCode).SendKeys(code);
            Thread.Sleep(1000);
            driver.FindElementById(ScreensControls.OrgPOCTitle).SendKeys(title);
            Thread.Sleep(1000);
            driver.FindElementById(ScreensControls.OrgPOCSave).Click();
            Thread.Sleep(8000);
            var errorMsg = driver.FindElementByClassName("recordPopupErrorMessages").Text;
            System.Diagnostics.Debug.WriteLine(!string.IsNullOrWhiteSpace(errorMsg) ? errorMsg : "Success");
            Thread.Sleep(2000);
            driver.FindElementById(ScreensControls.OrgPOCCancel).Click();
            Thread.Sleep(4000);

        }


    }
}
