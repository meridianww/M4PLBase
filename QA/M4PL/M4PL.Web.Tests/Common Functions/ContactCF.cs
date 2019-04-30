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
    public class ContactCF
    {
        public static void NavToContactDVS(ChromeDriver driver)
        {
            driver.FindElement(By.Id(LeftPanelControls.ConDVS)).Click();
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(2));
            var conStatusBar = wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(By.Id(ContactControls.ConStatusBar)));
        }

        public static void ConOnClickSave(ChromeDriver driver)
        {
            driver.FindElement(By.Id(ContactControls.conSave)).Click();
        }

        public static void ConOnClickCancel(ChromeDriver driver)
        {
            driver.FindElement(By.Id(ContactControls.conCancel)).Click();
        }

        public static void CreateContact(ChromeDriver driver, string fName, string lName, string workEMail)
        {
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(10));
            driver.FindElement(By.Id(ContactControls.firstName)).SendKeys(fName);
            driver.FindElement(By.Id(ContactControls.lastName)).SendKeys(lName);
            driver.FindElement(By.Id(ContactControls.workEmail)).SendKeys(workEMail);

        }

        public static void EditContact(ChromeDriver driver, string middleName, string indEmail)
        {
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(10));
            driver.FindElement(By.Id(ContactControls.middleName)).SendKeys(middleName);
            driver.FindElement(By.Id(ContactControls.indEmail)).SendKeys(indEmail);
        }

    }
}
