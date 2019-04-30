using M4PL.Web.Tests.Common;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System;
using System.Threading;

namespace M4PL.Web.Tests.Organization
{
    public class CreateOrganizationandDetails
    {

        public static void Add(String Code, String Title, ChromeDriver driver)
        {

            Thread.Sleep(4000);
            driver.FindElementById(LeftPanelXPath.OrgDVS).Click();
            Thread.Sleep(10000);
            driver.FindElementById(RibbonXPath.New).Click();
            Thread.Sleep(15000);
            driver.FindElementById(ScreensControls.OrgCode).SendKeys(Code);
            Thread.Sleep(2000);
            driver.FindElementById(ScreensControls.OrgTitle).SendKeys(Title);
            Thread.Sleep(1000);
            driver.FindElementById(ScreensControls.OrgGroupDrpdwn).Click();
            Thread.Sleep(2000);
            driver.FindElementById(ScreensControls.OrgGrpbrokerage).Click();
            Thread.Sleep(1000);
            ImageUpload.FileUpload(driver, ScreensControls.OrgImage, @"C:\Users\Public\Pictures\M4PL Logo.PNG");
            Thread.Sleep(5000);
            driver.FindElementById(ScreensControls.OrgSave).Click();
            Thread.Sleep(12000);
            driver.FindElementById(ScreensControls.OrgSaveOk).Click();
            Thread.Sleep(12000);
        }

        public static void Edit(String SearchCode, ChromeDriver driver)
        {
            driver.FindElementById(RibbonXPath.ToggleFilter).Click();
            Thread.Sleep(2000);
            driver.FindElementById(ScreensControls.ToogleFilterCode).SendKeys(SearchCode);
            Thread.Sleep(2000);
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            IWebElement searchBox = driver.FindElement(By.Id(ScreensControls.SearchedRow));
            action.ContextClick(searchBox).Perform();
            Thread.Sleep(3000);
            driver.FindElementById(ScreensControls.OrgEdit).Click();
            Thread.Sleep(2000);
        }


    }
}
