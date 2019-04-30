using M4PL.Web.Tests.Common;
using M4PL.Web.Tests.Utilities;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System;
using System.Threading;

namespace M4PL.Web.Tests.Contact
{
     public class ContactTest
    {
        RandomGenerator randomValues = new RandomGenerator();
        public String Add(ChromeDriver driver)
        {
            Thread.Sleep(9000);
            driver.FindElementByXPath(ContactXPath.contactDataViewScreen).Click();
            Thread.Sleep(5000);
            driver.FindElementByXPath(ContactXPath.newRibbonBtn).Click();
            Thread.Sleep(3000);
            String emailID = randomValues.GenerateEmailForDomain("test.com");
            driver.FindElementById(ContactXPath.firstName).SendKeys(randomValues.AppendRandomStringTo("FirstName"));
            driver.FindElementByXPath(ContactXPath.lastName).SendKeys(randomValues.AppendRandomStringTo("LastName"));
            driver.FindElementByXPath(ContactXPath.jobTitle).SendKeys(randomValues.AppendRandomStringTo("JobTitle"));
            driver.FindElementByXPath(ContactXPath.indEmail).SendKeys(emailID);
            driver.FindElementByXPath(ContactXPath.conSave).Click();
            Thread.Sleep(5000);
            driver.FindElementByXPath(ContactXPath.conSaveOKBtn).Click();
            return emailID;

        }

        public void createContactParam(String FirstName, String LastName, String JobTitle, String IndEmail, ChromeDriver driver)
        {
            Thread.Sleep(2000);
            driver.FindElementByXPath(ContactXPath.contactDataViewScreen).Click();
            Thread.Sleep(3000);
            driver.FindElementById(RibbonXPath.New).Click();
            Thread.Sleep(5000);
            driver.FindElementById(ContactXPath.firstName).SendKeys(FirstName);
            Thread.Sleep(2000);
            driver.FindElementById(ContactXPath.lastName).SendKeys(LastName);
            Thread.Sleep(2000);
            driver.FindElementById(ContactXPath.jobTitle).SendKeys(JobTitle);
            Thread.Sleep(2000);
            driver.FindElementById(ContactXPath.indEmail).SendKeys(IndEmail);
            Thread.Sleep(2000);
            driver.FindElementByXPath(ContactXPath.conSave).Click();
            Thread.Sleep(5000);
            driver.FindElementByXPath(ContactXPath.conSaveOKBtn).Click();
        }

        public void Invalid(string fn, string ln, string email, ChromeDriver driver)
        {
            Thread.Sleep(9000);
            driver.FindElementByXPath(ContactXPath.contactDataViewScreen).Click();
            Thread.Sleep(5000);
            driver.FindElementByXPath(ContactXPath.newRibbonBtn).Click();
            Thread.Sleep(3000);
            driver.FindElementByXPath(ContactXPath.firstName).SendKeys(fn);
            Thread.Sleep(2000);
            driver.FindElementByXPath(ContactXPath.lastName).SendKeys(ln);
            Thread.Sleep(2000);
            driver.FindElementById(ContactXPath.indEmail).SendKeys(email);
            Thread.Sleep(2000);
            driver.FindElementById(ContactXPath.conSave).Click();
            Thread.Sleep(3000);
            var errorMsg = driver.FindElementByClassName("errorMessages").Text;
            System.Diagnostics.Debug.WriteLine(!string.IsNullOrWhiteSpace(errorMsg) ? errorMsg : "Succeeded");
            Thread.Sleep(2000);
            driver.FindElementById(ContactXPath.conCancel).Click();
            Thread.Sleep(2000);
        }


       
    }
}
