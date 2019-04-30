using M4PL.Web.Tests.Common;
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
    class OrgCreateCredentials
    {
        public static void createOrgCredDetails(String Code, String Title, ChromeDriver driver)
        {
            driver.FindElementById(ScreensControls.OrgCredTab).Click();
            Thread.Sleep(5000);
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            Thread.Sleep(1000);
            IWebElement CredGrid1 = driver.FindElement(By.Id(ScreensControls.OrgCredGrid));
            Thread.Sleep(1000);
            action.ContextClick(CredGrid1).Perform();
            Thread.Sleep(3000);
            driver.FindElementById(ScreensControls.OrgCredNew).Click();
            Thread.Sleep(7000);
            driver.FindElementById(ScreensControls.OrgCredCode).SendKeys(Code);
            Thread.Sleep(1000);
            driver.FindElementById(ScreensControls.OrgCredTitle).SendKeys(Title);
            Thread.Sleep(1000);
            driver.FindElementById(ScreensControls.OrgCredExpDateDrpDwn).Click();
            Thread.Sleep(1000);
            driver.FindElementById(ScreensControls.OrgCredExpDateToday).Click();
            Thread.Sleep(1000);
            driver.FindElementById(ScreensControls.OrgCredSave).Click();
            Thread.Sleep(8000);
            driver.FindElementById(ScreensControls.OrgCredSaveOk).Click();
            Thread.Sleep(8000);
        }

        public static void editOrgCredDetails(ChromeDriver driver)
        {
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            Thread.Sleep(1000);
            IWebElement CredGridEdit = driver.FindElement(By.Id(ScreensControls.OrgCredRowRightClk));
            Thread.Sleep(1000);
            action.ContextClick(CredGridEdit).Perform();
            Thread.Sleep(3000);
            driver.FindElementById(ScreensControls.OrgCredEdit).Click();
            Thread.Sleep(7000);
            driver.FindElementById(ScreensControls.OrgCredAttchmentPanel).Click();
            Thread.Sleep(8000);
            driver.FindElementById(ScreensControls.OrgCredAttachmentNew).Click();
            Thread.Sleep(8000);
            IWebElement El = driver.FindElement(By.Id(ScreensControls.OrgCredAttachmentBrowse));
            El.SendKeys("C:\\Users\\Public\\Pictures\\M4PL Logo.PNG");
            Thread.Sleep(7000);
            driver.FindElementById(ScreensControls.OrgCredAttachmentSaveChanges).Click();
            Thread.Sleep(7000);
            driver.FindElementById(ScreensControls.OrgCredSave).Click();
            Thread.Sleep(7000);
            driver.FindElementById(ScreensControls.OrgCredSaveOk).Click();
            Thread.Sleep(7000);

        }

        public static void Invalid(string code, string title, ChromeDriver driver)
        {
            driver.FindElementById(ScreensControls.OrgCredTab).Click();
            Thread.Sleep(5000);
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            Thread.Sleep(1000);
            IWebElement CredGrid1 = driver.FindElement(By.Id(ScreensControls.OrgCredGrid));
            Thread.Sleep(1000);
            action.ContextClick(CredGrid1).Perform();
            Thread.Sleep(3000);
            driver.FindElementById(ScreensControls.OrgCredNew).Click();
            Thread.Sleep(7000);
            driver.FindElementById(ScreensControls.OrgCredCode).SendKeys(code);
            Thread.Sleep(1000);
            driver.FindElementById(ScreensControls.OrgCredTitle).SendKeys(title);
            Thread.Sleep(1000);
            driver.FindElementById(ScreensControls.OrgCredSave).Click();
            Thread.Sleep(2000);
            var errorMsg = driver.FindElementByClassName("recordPopupErrorMessages").Text;
            System.Diagnostics.Debug.WriteLine(!string.IsNullOrWhiteSpace(errorMsg) ? errorMsg : "Succeeded");
            Thread.Sleep(2000);
            driver.FindElementById(ScreensControls.OrgCredCancel).Click();
            Thread.Sleep(3000);


        }
    }
}
