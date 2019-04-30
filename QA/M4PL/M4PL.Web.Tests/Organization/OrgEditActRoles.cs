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
    class OrgEditActRoles
    {
        public static void editActRoles(ChromeDriver driver)
        {
            driver.FindElementById(LeftPanelXPath.OrgActRole).Click();
            Thread.Sleep(7000);
            driver.FindElementById(RibbonXPath.ToggleFilter).Click();
            Thread.Sleep(4000);
            driver.FindElementById(ScreensControls.OrgActRolCodeToggleDrpdwnIcn).Click();
            Thread.Sleep(3000);
            driver.FindElementById(ScreensControls.OrgActRolCodeSysadmn).Click();
            Thread.Sleep(6000);
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            Thread.Sleep(1000);
            IWebElement ActGrid = driver.FindElement(By.Id(ScreensControls.OrgActRolCodSearchedRow));
            Thread.Sleep(1000);
            action.ContextClick(ActGrid).Perform();
            Thread.Sleep(6000);
            driver.FindElementById(ScreensControls.OrgActRolEdit).Click();
            Thread.Sleep(7000);
            //driver.FindElementById(ScreensControls.OrgActRolSecurity).Click();
            //Thread.Sleep(2000);
            //driver.FindElementById(ScreensControls.OrgActRolSecNew).Click();
            //Thread.Sleep(1000);
            driver.FindElementById(ScreensControls.OrgActRolTypeDrpdwn).Click();
            Thread.Sleep(1000);
            driver.FindElementById(ScreensControls.OrgActRolTypConsultant).Click();
            Thread.Sleep(1000);
            driver.FindElementById(ScreensControls.OrgActRolJobGWResponsible).Click();
            Thread.Sleep(1000);
            driver.FindElementById(ScreensControls.OrgActRolUpdate).Click();
            Thread.Sleep(7000);
            driver.FindElementById(ScreensControls.OrgActRolSaveOk).Click();
            Thread.Sleep(3000);
            driver.FindElementById(ScreensControls.OrgActRolCancel).Click();
            Thread.Sleep(5000);
        }

    
    }
}
