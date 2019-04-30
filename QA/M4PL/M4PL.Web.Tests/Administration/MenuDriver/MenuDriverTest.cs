using M4PL.Web.Tests.Common;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System;
using System.IO;
using System.Threading;

namespace M4PL.Web.Tests.Administration.MenuDriver
{
    [TestClass]
    public class MenuDriverTest
    {
        ChromeDriver _chromeDriver = new ChromeDriver((Directory.GetParent((Directory.GetParent(Environment.CurrentDirectory)).ToString())).ToString() + @"\Utilities\ExternalFiles");
        LoginTest login = new LoginTest();

        [TestMethod]
        public void Run()
        {
            LoginTest.loginToApplication("diksha", "12345", _chromeDriver);
            Add(_chromeDriver, MenuDriverXPath.MainModuleOptionScanner, ".07", "testTitle", "test Title", true, false, "test Title", @"C:\Users\dharmendra.verma\Desktop\download.PNG", "DataView", MenuDriverXPath.PrgmDrpdwnOptionMenus, MenuDriverXPath.OptionLevelSystems);
            Edit(_chromeDriver, "02.06.07", "updated");
        }

        public static void NavigateToPage(ChromeDriver driver)
        {
            Thread.Sleep(4000);
            driver.FindElementById(LeftPanelXPath.MnuDrvr).Click();
            Thread.Sleep(10000);
        }

        public static void ToggleFilterFirstRecord(ChromeDriver driver, string searchBreakDownStructure)
        {
            driver.FindElementById(RibbonXPath.ToggleFilter).Click();
            Thread.Sleep(2000);
            driver.FindElementById(MenuDriverXPath.ToggleFilterHeaderTextBoxBreakDownStructure).SendKeys(searchBreakDownStructure);
            Thread.Sleep(2000);
        }

        public static void Add(ChromeDriver driver, string mainModule, string breakdownStructure, string title, string tabOver, bool isMenu, bool isRibbon, string ribbonTabName, string imagePath, string executeProgram, string programType, string optionLevel)
        {
            NavigateToPage(driver);

            driver.FindElementById(RibbonXPath.New).Click();
            Thread.Sleep(15000);

            driver.FindElementById(MenuDriverXPath.MainModuleDrpdwn).Click();
            Thread.Sleep(2000);

            driver.FindElementById(mainModule).Click();
            Thread.Sleep(2000);

            driver.FindElementById(MenuDriverXPath.BrkdwnStructure).SendKeys(breakdownStructure);
            Thread.Sleep(1000);

            driver.FindElementById(MenuDriverXPath.Title).SendKeys(title);
            Thread.Sleep(1000);

            driver.FindElementById(MenuDriverXPath.TabOver).SendKeys(tabOver);
            Thread.Sleep(1000);

            if (isMenu)
            {
                driver.FindElementById(MenuDriverXPath.Menu).Click();
                Thread.Sleep(1000);
            }

            if (isRibbon)
            {
                driver.FindElementById(MenuDriverXPath.Ribbon).Click();
                Thread.Sleep(1000);
            }

            driver.FindElementById(MenuDriverXPath.RibbonTabName).SendKeys(ribbonTabName);
            Thread.Sleep(1000);

            ImageUpload.FileUpload(driver, MenuDriverXPath.IconVerySmall, imagePath);
            Thread.Sleep(5000);

            ImageUpload.FileUpload(driver, MenuDriverXPath.IconSmall, imagePath);
            Thread.Sleep(5000);

            ImageUpload.FileUpload(driver, MenuDriverXPath.IconMedium, imagePath);
            Thread.Sleep(5000);

            ImageUpload.FileUpload(driver, MenuDriverXPath.IconLarge, imagePath);
            Thread.Sleep(5000);

            driver.FindElementById(MenuDriverXPath.ExecutePrgm).SendKeys(executeProgram);
            Thread.Sleep(1000);

            driver.FindElementById(MenuDriverXPath.PrgmDrpdwn).Click();
            Thread.Sleep(2000);

            driver.FindElementById(programType).Click();
            Thread.Sleep(2000);

            driver.FindElementById(MenuDriverXPath.OptionLevelDrpdwn).Click();
            Thread.Sleep(2000);

            driver.FindElementById(optionLevel).Click();
            Thread.Sleep(2000);

            driver.FindElementById(MenuDriverXPath.Save).Click();
            Thread.Sleep(12000);
        }

        public static void Edit(ChromeDriver driver, string searchBreakDownStructure, string title)
        {
            NavigateToPage(driver);
            ToggleFilterFirstRecord(driver, searchBreakDownStructure);
            new OpenQA.Selenium.Interactions.Actions(driver).ContextClick(driver.FindElement(By.Id(MenuDriverXPath.GridData))).Perform();
            Thread.Sleep(3000);
            driver.FindElementById(MenuDriverXPath.Edit).Click();
            Thread.Sleep(2000);
            driver.FindElementById(MenuDriverXPath.Title).SendKeys(title);
            Thread.Sleep(1000);
            driver.FindElementById(MenuDriverXPath.Save).Click();
            Thread.Sleep(12000);
        }

        public static void Invalid(string breakDownStructure, string title, ChromeDriver driver)
        {
            NavigateToPage(driver);

            driver.FindElementById(RibbonXPath.New).Click();
            Thread.Sleep(15000);
            driver.FindElementById(RibbonXPath.Save).Click();
            Thread.Sleep(9000);
            var errorMsg = driver.FindElementByClassName("errorMessages").Text;
            System.Diagnostics.Debug.WriteLine(!string.IsNullOrWhiteSpace(errorMsg) ? errorMsg : "Success");
            Thread.Sleep(4000);
            driver.FindElementById(MenuDriverXPath.Cancel).Click();
            Thread.Sleep(3000);


        }
    }
}
