using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System;
using System.Threading;

namespace M4PL.Web.Tests.Program
{
    public class PrgMvocRefQuestionTest
    {
        public static void Add(string mVOCSecCode, string mVOCSecTitle, ChromeDriver driver)
        {

            Thread.Sleep(4000);
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            IWebElement MVOCChildGrid = driver.FindElement(By.Id(ProgramXPath.PrgMVOCSecondryGrid));
            action.ContextClick(MVOCChildGrid).Perform();
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.PrgMVOCSecondryNew).Click();
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgMVOCSecondryCode).SendKeys(mVOCSecCode);
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgMVOCSecondryTitle).SendKeys(mVOCSecTitle);
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgMVOCSecondrySave).Click();
            Thread.Sleep(5000);
            driver.FindElementById(ProgramXPath.PrgMVOCSecondrySaveOk).Click();
            Thread.Sleep(5000);

        }

        public static void Edit( ChromeDriver driver)
        {
            Thread.Sleep(4000);
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            IWebElement MVOCChildGridedit = driver.FindElement(By.Id(ProgramXPath.PrgMVOCSecondryGrid));
            action.ContextClick(MVOCChildGridedit).Perform();
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.PrgMVOCSecondryNew).Click();
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgMVOCSecondryTypeYesNo).Click();
            Thread.Sleep(2000);
            driver.FindElementById(ProgramXPath.PrgMVOCSecondryType_YNDefault).Click();
            Thread.Sleep(2000);
            driver.FindElementById(ProgramXPath.PrgMVOCSecondrySave).Click();
            Thread.Sleep(6000);
            driver.FindElementById(ProgramXPath.PrgMVOCSecondrySaveOk).Click();
            Thread.Sleep(4000);
        }

        public static void InvalidTest(string code, ChromeDriver driver)
        {
            Thread.Sleep(4000);
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            IWebElement MVOCChildGridRec = driver.FindElement(By.Id(ProgramXPath.PrgMVOCSecondryGrid));
            action.ContextClick(MVOCChildGridRec).Perform();
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.PrgMVOCSecondryNew).Click();
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgMVOCSecondryCode).SendKeys(code);
            Thread.Sleep(3000);
            var errorMsg = driver.FindElementByClassName("recordPopupErrorMessages").Text;
            System.Diagnostics.Debug.WriteLine(!string.IsNullOrWhiteSpace(errorMsg) ? errorMsg : "Succeeded");
            Thread.Sleep(2000);
            driver.FindElementById(ProgramXPath.PrgMVOCSecondryCancel).Click();
            Thread.Sleep(2000);
        }
    }
}
