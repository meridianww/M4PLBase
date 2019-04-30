using M4PL.Web.Tests.Common;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Interactions;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace M4PL.Web.Tests.Organization
{
    class OrgCreateRefRoles
    {
        public static void refRoles(string code, string title, string fName, string lName, string jTitle, string bPhone, string indEml, ChromeDriver driver)
        {
            driver.FindElementById(LeftPanelXPath.OrgRefRole).Click();
            Thread.Sleep(7000);
            driver.FindElementById(RibbonXPath.New).Click();
            Thread.Sleep(7000);
            driver.FindElementById(ScreensControls.OrgRefRolCode).SendKeys(code);
            Thread.Sleep(1000);
            driver.FindElementById(ScreensControls.OrgRefRolTitle).SendKeys(title);
            Thread.Sleep(1000);
            driver.FindElementById(ScreensControls.OrgRefRolDefault).Click();
            Thread.Sleep(3000);
            //driver.FindElementById(ScreensControls.OrgRefRolTypeDrpdwn).Click();
            //Thread.Sleep(4000);
            //driver.FindElementById(ScreensControls.OrgRefRoleTypeDriver).Click();
            //Thread.Sleep(4000);
            driver.FindElementById(ScreensControls.OrgRefRolContactCard).Click();
            Thread.Sleep(5000);
            driver.FindElementById(ScreensControls.OrgRRConFN).SendKeys(fName);
            Thread.Sleep(3000);
            driver.FindElementById(ScreensControls.OrgRRConLN).SendKeys(lName);
            Thread.Sleep(1000);
            driver.FindElementById(ScreensControls.OrgRRConJT).SendKeys(jTitle);
            Thread.Sleep(1000);
            driver.FindElementById(ScreensControls.OrgRRBusinessPhn).SendKeys(bPhone);
            Thread.Sleep(1000);
            driver.FindElementById(ScreensControls.OrgRRConIndEml).SendKeys(indEml);
            Thread.Sleep(1000);
            driver.FindElementById(ScreensControls.OrgRRConSaveIcn).Click();
            Thread.Sleep(9000);
            driver.FindElementById(ScreensControls.OrgRefRolSave).Click();
            Thread.Sleep(8000);
            driver.FindElementById(ScreensControls.OrgRefRolSaveOk).Click();
            Thread.Sleep(4000);
            driver.FindElementById(ScreensControls.OrgRefRolCancel).Click();
            Thread.Sleep(5000);
        }

        public static void editRefRoles(string orgRefRolToggleFilterSearchCode, ChromeDriver driver)
        {
            // driver.FindElementById(LeftPanelXPath.OrgRefRole).Click();
            Thread.Sleep(3000);
            driver.FindElementById(RibbonXPath.ToggleFilter).Click();
            Thread.Sleep(2000);
            driver.FindElementById(ScreensControls.OrgRefRolToggleFilterCode).SendKeys(orgRefRolToggleFilterSearchCode);
            Thread.Sleep(5000);

            Actions action = new Actions(driver);
            IWebElement searchBox = driver.FindElement(By.Id(ScreensControls.OrgRefRolToggleFilterRow));
            action.ContextClick(searchBox).Perform();
            Thread.Sleep(6000);
            driver.FindElementById(ScreensControls.OrgRefRolEdit).Click();
            Thread.Sleep(6000);
            driver.FindElementById(ScreensControls.OrgRefRolOrg).Click();
            Thread.Sleep(1000);
            driver.FindElementById(ScreensControls.OrgRefRolProgram).Click();
            Thread.Sleep(1000);
            driver.FindElementById(ScreensControls.OrgRefRolJob).Click();
            Thread.Sleep(1000);
            driver.FindElementById(ScreensControls.OrgRefRolSecurity).Click();
            Thread.Sleep(8000);
            driver.FindElementById(ScreensControls.OrgRefRolSecNew).Click();
            Thread.Sleep(5000);
            driver.FindElementById(ScreensControls.OrgRRSecModuleDrpdwn).Click();
            Thread.Sleep(2000);
            driver.FindElementById(ScreensControls.OrgRRSecModuleOpJobOp).Click();
            Thread.Sleep(2000);
            driver.FindElementById(ScreensControls.OrgRRSecOptionLevelDrpdwn).Click();
            Thread.Sleep(4000);
            driver.FindElementById(ScreensControls.OrgRRSecOptionNoRights).Click();
            Thread.Sleep(2000);
            driver.FindElementById(ScreensControls.OrgRRSecAccessLevelDrpdwn).Click();
            Thread.Sleep(3000);
            driver.FindElementById(ScreensControls.OrgRRSecAccessNo).Click();
            Thread.Sleep(2000);
            driver.FindElementById(ScreensControls.OrgRRSecStatusDrpdwn).Click();
            Thread.Sleep(2000);
            driver.FindElementById(ScreensControls.OrgRRSecStatusActive).Click();
            Thread.Sleep(5000);
            driver.FindElementById(ScreensControls.OrgRRSecOutsideRow).Click();
            Thread.Sleep(6000);
            driver.FindElementById(ScreensControls.OrgRRSecSaveChanges).Click();
            Thread.Sleep(7000);
            driver.FindElementById(ScreensControls.OrgRefRolDetail).Click();
            Thread.Sleep(5000);
            driver.FindElementById(ScreensControls.OrgRefRolUpdate).Click();
            Thread.Sleep(7000);
            driver.FindElementById(ScreensControls.OrgRefRolSaveOk).Click();
            Thread.Sleep(5000);
            driver.FindElementById(ScreensControls.OrgRefRolCancel).Click();
            Thread.Sleep(5000);

        }

        public static void Invalid(string code, string title, ChromeDriver driver)
        {
            driver.FindElementById(LeftPanelXPath.OrgRefRole).Click();
            Thread.Sleep(7000);
            driver.FindElementById(RibbonXPath.New).Click();
            Thread.Sleep(7000);
            driver.FindElementById(ScreensControls.OrgRefRolCode).SendKeys(code);
            Thread.Sleep(1000);
            driver.FindElementById(ScreensControls.OrgRefRolTitle).SendKeys(title);
            Thread.Sleep(1000);
            driver.FindElementById(ScreensControls.OrgRefRolSave).Click();
            Thread.Sleep(8000);
            var errorMsg = driver.FindElementByClassName("errorMessages").Text;
            System.Diagnostics.Debug.WriteLine(!string.IsNullOrWhiteSpace(errorMsg) ? errorMsg : "Success");
            Thread.Sleep(2000);
            driver.FindElementById(ScreensControls.OrgRefRolCancel).Click();
            Thread.Sleep(4000);
        }

        public static void refRoles(string code, string title, ChromeDriver driver)
        {
            driver.FindElementById(LeftPanelXPath.OrgRefRole).Click();
            Thread.Sleep(7000);
            driver.FindElementById(RibbonXPath.New).Click();
            Thread.Sleep(7000);
            driver.FindElementById(ScreensControls.OrgRefRolCode).SendKeys(code);
            Thread.Sleep(1000);
            driver.FindElementById(ScreensControls.OrgRefRolTitle).SendKeys(title);
            Thread.Sleep(1000);
            driver.FindElementById(ScreensControls.OrgRefRolDefault).Click();
            Thread.Sleep(3000);
            driver.FindElementById(ScreensControls.OrgRefRolSave).Click();
            Thread.Sleep(8000);
            driver.FindElementById(ScreensControls.OrgRefRolSaveOk).Click();
            Thread.Sleep(4000);
            driver.FindElementById(ScreensControls.OrgRefRolSecurity).Click();
            Thread.Sleep(5000);
            driver.FindElementById(ScreensControls.OrgRefRolSecNew).Click();
            Thread.Sleep(5000);
            driver.FindElementById(ScreensControls.OrgRRSecModuleDrpdwn).Click();
            Thread.Sleep(2000);
            driver.FindElementById(ScreensControls.OrgRRSecModuleOpJobOp).Click();
            Thread.Sleep(2000);
            driver.FindElementById(ScreensControls.OrgRRSecOptionLeveltxtId).SendKeys("Systems");
            Thread.Sleep(4000);
            //driver.FindElementById(ScreensControls.OrgRRSecOptionNoRights).Click();
           // Thread.Sleep(2000);
            driver.FindElementById(ScreensControls.OrgRRSecAccessLeveltxtId).SendKeys("Add, Edit & Delete");
            Thread.Sleep(3000);
           // driver.FindElementById(ScreensControls.OrgRRSecAccessNo).Click();
           // Thread.Sleep(2000);
            driver.FindElementById(ScreensControls.OrgRRSecStatusDrpdwn).Click();
            Thread.Sleep(2000);
            driver.FindElementById(ScreensControls.OrgRRSecStatusActive).Click();
            Thread.Sleep(5000);
            driver.FindElementById(ScreensControls.OrgRRSecOutsideRow).Click();
            Thread.Sleep(6000);
            driver.FindElementById(ScreensControls.OrgRRSecSaveChanges).Click();
            Thread.Sleep(7000);
            driver.FindElementById(ScreensControls.OrgRefRolUpdate).Click();
            Thread.Sleep(5000);
            driver.FindElementById(RibbonXPath.Save).Click();
            Thread.Sleep(5000);
            driver.FindElementById(RibbonXPath.DataShtViewBtn).Click();
            Thread.Sleep(5000);

        }
    }
}
