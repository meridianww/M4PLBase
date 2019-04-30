using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Support.UI;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace M4PL.Web.Tests.Organization
{
    class OrgEditRoles_RespDetails
    {
        public static void editRolesRespDetails(ChromeDriver driver)
        {
            driver.FindElementById(ScreensControls.OrgRoleResTab).Click();
            Thread.Sleep(4000);
           OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            Thread.Sleep(1000);
            IWebElement rolesGrid = driver.FindElement(By.XPath(ScreensControls.OrgRRSearchedCode));
            Thread.Sleep(1000);
            action.ContextClick(rolesGrid).Perform();
            Thread.Sleep(3000);
            driver.FindElementById(ScreensControls.OrgRREdit).Click();
            Thread.Sleep(7000);
            driver.FindElementById(ScreensControls.OrgRRType).Click();
            Thread.Sleep(1000);
            driver.FindElementById(ScreensControls.OrgRRRoleTypeAgent).Click();
            Thread.Sleep(2000);
            driver.FindElementById(ScreensControls.OrgRRJobAnalyst).Click();
            Thread.Sleep(1000);
            driver.FindElementById(ScreensControls.OrgRefRolSave).Click();
            Thread.Sleep(5000);
            driver.FindElementById(ScreensControls.OrgRRSaveOk).Click();
            Thread.Sleep(4000);

        }
    }
}
