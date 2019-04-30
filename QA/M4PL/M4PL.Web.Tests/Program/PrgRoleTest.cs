using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System;
using System.Threading;

namespace M4PL.Web.Tests.Program
{
    public class PrgRoleTest
    {
        public static void Add(string refRole, string prgRole, string contactId, ChromeDriver driver)
        {
            driver.FindElementById(ProgramXPath.PrgContacts).Click();
            Thread.Sleep(4000);
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            IWebElement prgRoleGrid = driver.FindElement(By.Id(ProgramXPath.PrgContactGrid));
            action.ContextClick(prgRoleGrid).Perform();
            Thread.Sleep(6000);


            driver.FindElementById(ProgramXPath.PrgContactRoleCode).SendKeys(refRole);
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgContactPrgRoleCode).SendKeys(prgRole);
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgContactId).SendKeys(contactId);

            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgContactSave).Click();
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.PrgContactSaveOk).Click();
            Thread.Sleep(5000);

        }

        public static void Edit(string refRole, string prgRole, string contactId, ChromeDriver driver)
        {
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            Thread.Sleep(1000);
            IWebElement prgRoleGridEdit = driver.FindElement(By.Id(ProgramXPath.PrgContactGrid_Record));
            Thread.Sleep(1000);
            action.ContextClick(prgRoleGridEdit).Perform();
            Thread.Sleep(3000);
            driver.FindElementById(ProgramXPath.PrgContactEdit).Click();
            Thread.Sleep(7000);
            driver.FindElementById(ProgramXPath.PrgContactRoleCode).SendKeys(refRole);
            Thread.Sleep(2000);
            driver.FindElementById(ProgramXPath.PrgContactPrgRoleCode).SendKeys(prgRole);
            Thread.Sleep(2000);
            driver.FindElementById(ProgramXPath.PrgContactId).SendKeys(contactId);

            Thread.Sleep(2000);
            driver.FindElementById(ProgramXPath.PrgContactSave).Click();
            Thread.Sleep(4000);
            driver.FindElementById(ProgramXPath.PrgContactSaveOk).Click();
            Thread.Sleep(4000);
        }
    }
}
