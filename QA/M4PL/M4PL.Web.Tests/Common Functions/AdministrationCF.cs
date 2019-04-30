using M4PL.Web.Tests.Controls;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Support.UI;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Web.Tests.Common_Functions
{
    public class AdministrationCF
    {
        public static void NavToMenuDriver(ChromeDriver driver)
        {
            driver.FindElement(By.Id(LeftPanelControls.MnuDrvr)).Click();
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(2));
            var mnStatusBar = wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(By.Id(AdministrationControls.MDStatusBar)));
        }

        public static void NavToSysMessage(ChromeDriver driver)
        {
            driver.FindElement(By.Id(LeftPanelControls.SysMsg)).Click();
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(2));
            var sysMsgStatusBar = wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(By.Id(AdministrationControls.SysMsgStatusBar)));
        }

        public static void NavToMessageType(ChromeDriver driver)
        {
            driver.FindElement(By.Id(LeftPanelControls.MsgTyp)).Click();
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(2));
            var messageTypeStatusBar = wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(By.Id(AdministrationControls.MsgTypStatusBar)));
        }

        public static void NavToSysRef(ChromeDriver driver)
        {
            driver.FindElement(By.Id(LeftPanelControls.SysRef)).Click();
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(2));
            var sysRefStatusBar = wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(By.Id(AdministrationControls.SysRefStatusBar)));
        }

        public static void NavToSysAcc(ChromeDriver driver)
        {
            driver.FindElement(By.Id(LeftPanelControls.SysAcc)).Click();
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(2));
            var sysAccStatusBar = wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(By.Id(AdministrationControls.SysAccStatusBar)));
        }

        public static void NavToDBVal(ChromeDriver driver)
        {
            driver.FindElement(By.Id(LeftPanelControls.DBValdtn)).Click();
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(2));
            var dbValStatusBar = wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(By.Id(AdministrationControls.DBValStatusBar)));
        }
    }
}
